import re
import os
import argparse

def process_sqf_files(root_dir):
    # Regex hierarchy to skip comments and strings, then target btc_ patterns
    pattern = r"(/\*[\s\S]*?\*/|//.*|\".*?\"|'.*?')|(\bbtc_(?:(?P<comp>\w+)_)?fnc_(?P<name>\w+)\b)"

    # This list will store our audit trail
    changes_log = []

    def replacement_logic(match, current_file_path):
        # If group 1 (comments/strings) matched, return as-is
        if match.group(1):
            return match.group(1)

        # Group 2 (our target) matched
        before = match.group(0)
        comp = match.group('comp') if match.group('comp') else "common"
        name = match.group('name')
        after = f"FUNC({comp},{name})"

        # Record the change: PATH BEFORE AFTER
        changes_log.append(f"{current_file_path} {before} {after}")
        return after

    stats = {"files": 0}

    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith(".sqf"):
                file_path = os.path.join(root, file)

                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()

                    # We use a lambda to pass the current file path into the logic function
                    new_content = re.sub(pattern, lambda m: replacement_logic(m, file_path), content)

                    if new_content != content:
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        stats["files"] += 1
                except Exception as e:
                    print(f"Error processing {file_path}: {e}")

    # Write the audit file
    log_filename = "replacement_log.txt"
    with open(log_filename, 'w', encoding='utf-8') as log_file:
        log_file.write("\n".join(changes_log))

    print(f"\n--- Refactor Complete ---")
    print(f"Files Modified: {stats['files']}")
    print(f"Total Replacements: {len(changes_log)}")
    print(f"Audit log saved to: {log_filename}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="SQF refactor with audit log.")
    parser.add_argument("directory", help="The root directory to search")
    args = parser.parse_args()

    if os.path.isdir(args.directory):
        process_sqf_files(args.directory)
    else:
        print("Invalid directory.")
