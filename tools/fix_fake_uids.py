#!/usr/bin/env python3
"""
Fix Fake UIDs Tool

Scans all TSCN files for fake human-readable UIDs and replaces them with
Godot-generated UIDs by opening and re-saving scenes in Godot.

Usage:
    python tools/fix_fake_uids.py --dry-run  # See what would be fixed
    python tools/fix_fake_uids.py            # Actually fix (requires Godot)
"""

import re
import sys
import subprocess
import argparse
from pathlib import Path
from typing import List, Tuple

# Patterns that indicate a fake UID (human-readable format)
FAKE_UID_PATTERNS = [
    r'uid://[a-z_]+_001"',  # e.g., uid://sundial_001
    r'uid://[a-z_]+_scene"',  # e.g., uid://player_scene
    r'uid://[a-z_]+_gen_runner_001"',  # e.g., uid://player_sprite_gen_runner_001
    r'uid://test_runner_scene"',
    r'uid://loading_screen"',
    r'uid://notification_system"',
    r'uid://scene_test_[ab]"',
    r'uid://item_slot_001"',
    r'uid://inventory_panel_001"',
    r'uid://dialogue_box_001"',
    r'uid://crafting_controller_001"',
    r'uid://weaving_minigame_001"',
    r'uid://moon_tears?_001"',  # moon_tears_001 and moon_tear_001
    r'uid://herb_identification_001"',
    r'uid://crafting_minigame_001"',
    r'uid://titan_battlefield_001"',
    r'uid://daedalus_workshop_001"',
    r'uid://binding_ward_failed_001"',
    r'uid://calming_draught_failed_001"',
    r'uid://reversal_elixir_failed_001"',
    r'uid://divine_blood_cutscene_001"',
    r'uid://scylla_transformation_001"',
    r'uid://scylla_petrification_001"',
    r'uid://sailing_first_001"',
    r'uid://sailing_final_001"',
    r'uid://epilogue_001"',
    r'uid://sacred_earth_001"',
    r'uid://settings_menu_001"',
    r'uid://debug_hud_001"',
    r'uid://farm_plot_001"',
    r'uid://house_door_001"',
    r'uid://loom_001"',
    r'uid://boat_001"',
    r'uid://recipe_001"',
    r'uid://sundial_001"',
    r'uid://player_scene_001"',
    r'uid://npc_circe_001"',
    r'uid://npc_hermes_001"',
    r'uid://npc_aeetes_001"',
    r'uid://npc_scylla_001"',
    r'uid://npc_daedalus_001"',
    r'uid://npc_base_001"',
]


def find_fake_uids(project_root: Path) -> List[Tuple[Path, str, int]]:
    """Find all TSCN files with fake UIDs."""
    fake_uid_files = []
    game_dir = project_root / "game"
    
    for tscn_file in game_dir.rglob("*.tscn"):
        content = tscn_file.read_text(encoding='utf-8')
        
        for pattern in FAKE_UID_PATTERNS:
            matches = re.finditer(pattern, content)
            for match in matches:
                # Find line number
                line_num = content[:match.start()].count('\n') + 1
                fake_uid_files.append((tscn_file, match.group(0), line_num))
    
    return fake_uid_files


def create_godot_tool_script(files_to_fix: List[Path]) -> str:
    """Create a Godot tool script to re-save scenes with proper UIDs."""
    script_content = '''@tool
extends EditorScript

func _run():
    var files = [
'''
    for f in files_to_fix:
        script_content += f'        "{f.as_posix()}",\n'
    
    script_content += '''    ]
    
    var fixed_count = 0
    var errors = []
    
    for path in files:
        print("Processing: " + path)
        var scene = load(path)
        if scene == null:
            errors.append("Failed to load: " + path)
            continue
            
        var result = ResourceSaver.save(scene, path)
        if result == OK:
            print("  ✓ Fixed: " + path)
            fixed_count += 1
        else:
            errors.append("Failed to save: " + path + " (error: " + str(result) + ")")
    
    print("\\n=== Results ===")
    print("Fixed: " + str(fixed_count) + "/" + str(len(files)))
    if errors.size() > 0:
        print("\\nErrors:")
        for err in errors:
            print("  ✗ " + err)
'''
    return script_content


def main():
    parser = argparse.ArgumentParser(description='Fix fake UIDs in Godot TSCN files')
    parser.add_argument('--dry-run', action='store_true', 
                        help='Show what would be fixed without making changes')
    parser.add_argument('--project-root', type=Path, default=Path('.'),
                        help='Path to project root (default: current directory)')
    args = parser.parse_args()
    
    print("[SCAN] Scanning for fake UIDs...")
    fake_uids = find_fake_uids(args.project_root)
    
    if not fake_uids:
        print("[PASS] No fake UIDs found!")
        return 0
    
    print(f"\n[WARN] Found {len(fake_uids)} fake UID occurrences in {len(set(f[0] for f in fake_uids))} files:\n")
    
    # Group by file
    files_with_fake_uids = {}
    for file_path, uid, line in fake_uids:
        if file_path not in files_with_fake_uids:
            files_with_fake_uids[file_path] = []
        files_with_fake_uids[file_path].append((uid, line))
    
    for file_path, occurrences in files_with_fake_uids.items():
        print(f"  {file_path.relative_to(args.project_root)}")
        for uid, line in occurrences:
            print(f"    Line {line}: {uid}")
    
    if args.dry_run:
        print("\n[INFO] Dry run - no changes made.")
        print("   Run without --dry-run to fix (requires Godot editor)")
        return 0
    
    # Create tool script
    print("\n[INFO] Creating Godot tool script...")
    tool_script = create_godot_tool_script(list(files_with_fake_uids.keys()))
    tool_script_path = args.project_root / "tools" / "fix_uids_tool.gd"
    tool_script_path.write_text(tool_script, encoding='utf-8')
    print(f"   Created: {tool_script_path}")
    
    print("\n[INFO] Next steps:")
    print("   1. Open Godot editor")
    print("   2. Go to Project > Tools > Run Fix UIDs Tool")
    print("   3. Or run: godot --script tools/fix_uids_tool.gd")
    print("\n   ⚠️  NOTE: This tool requires Godot editor to generate proper UIDs")
    
    return 1


if __name__ == '__main__':
    sys.exit(main())
