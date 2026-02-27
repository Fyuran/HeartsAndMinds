import re
import os
import argparse
from pathlib import Path

# --- INTERNAL LOGIC ---
def get_native_path(root_dir, sqf_path_str):
    """Converts SQF path strings to system-native Path objects."""
    clean_path = sqf_path_str.replace('\\', os.sep).replace('/', os.sep)
    return Path(root_dir) / Path(clean_path).with_suffix('.sqf')

def verify_path(root_dir, sqf_path_str):
    """Checks if the file exists on the current OS."""
    return get_native_path(root_dir, sqf_path_str).exists()

# --- COLORS ---
RED, GREEN, BLUE, YELLOW, RESET = "\033[91m", "\033[92m", "\033[94m", "\033[93m", "\033[0m"

def run_validation(target, root):
    search_path = Path(target).resolve()
    root_path = Path(root).resolve()

    # Regex for FUNC assignments
    pattern = r"FUNC\((?P<comp>\w+),(?P<fnc>\w+)\)\s*=\s*compileScript\s*\[\"(?P<path>.*?)\.sqf\"\];"

    stats = {"valid": 0, "broken": 0}
    files = [search_path] if search_path.is_file() else list(search_path.rglob("*.sqf"))

    print(f"{BLUE}--- Validation Start ---{RESET}")
    print(f"{YELLOW}Scanning: {search_path}{RESET}")
    print(f"{YELLOW}Root:     {root_path}{RESET}\n")

    for sqf_file in files:
        try:
            content = sqf_file.read_text(encoding='utf-8')

            for match in re.finditer(pattern, content):
                # Calculate line number by counting newlines before the match start
                line_no = content.count('\n', 0, match.start()) + 1
                raw_path = match.group('path')

                if verify_path(root_path, raw_path):
                    stats["valid"] += 1
                else:
                    stats["broken"] += 1
                    # Detailed error reporting
                    print(f"{RED}[BROKEN PATH]{RESET} {sqf_file.name}:{line_no}")
                    print(f"   Line:   {match.group(0)}")
                    print(f"   Search: {get_native_path(root_path, raw_path)}\n")

        except Exception as e:
            print(f"{YELLOW}Error reading {sqf_file.name}: {e}{RESET}")

    print(f"{BLUE}--- Summary ---{RESET}")
    print(f"{GREEN}Valid Paths:  {stats['valid']}{RESET}")
    print(f"{RED}Broken Paths: {stats['broken']}{RESET}")

    total = stats['valid'] + stats['broken']
    if total > 0:
        print(f"Success Rate: {(stats['valid']/total)*100:.1f}%")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Validate SQF paths with line numbers.")
    parser.add_argument("target", help="The file or folder to scan for FUNC definitions")
    parser.add_argument("root", help="The root project folder for path verification")

    args = parser.parse_args()

    if Path(args.target).exists() and Path(args.root).is_dir():
        run_validation(args.target, args.root)
    else:
        print(f"{RED}Error: Check that both the target and the root directory exist.{RESET}")
