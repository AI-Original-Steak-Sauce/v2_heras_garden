#!/usr/bin/env python3
"""
Fix fake UIDs in Godot TSCN files.
Generates proper Godot-compatible UIDs and replaces fake human-readable ones.
"""

import os
import re
import base64
import struct
import random

def generate_godot_uid():
    """Generate a valid Godot UID (Base64-encoded 64-bit random value)."""
    # Godot uses 64-bit random values encoded in Base64
    # Format: uid://<base64-encoded-64-bit-value>
    # Using the same charset as Godot: a-z, 0-9 (no capital letters)
    uid_bytes = random.getrandbits(64).to_bytes(8, 'big')
    # Remove padding and use Godot's URL-safe base64 variant
    encoded = base64.urlsafe_b64encode(uid_bytes).decode('ascii').rstrip('=')
    # Godot uses lowercase only and hyphens instead of underscores in the encoded string
    encoded = encoded.lower().replace('_', '-')
    return f"uid://{encoded}"

def fix_uid_in_file(filepath):
    """Fix fake UIDs in a single TSCN file."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Pattern to match fake UIDs like uid://sundial_001, uid://boat_001, etc.
        # Fake UIDs contain underscores, letters only, or human-readable patterns
        fake_uid_pattern = r'uid://[a-zA-Z_][a-zA-Z0-9_]*'
        
        def replace_uid(match):
            old_uid = match.group(0)
            new_uid = generate_godot_uid()
            print(f"  Replacing: {old_uid} -> {new_uid}")
            return new_uid
        
        # Check if file has fake UIDs
        fake_uids_found = re.findall(fake_uid_pattern, content)
        fake_uids = [uid for uid in fake_uids_found if not is_valid_godot_uid(uid)]
        
        if not fake_uids:
            return False, "No fake UIDs found"
        
        # Replace all fake UIDs
        new_content = re.sub(fake_uid_pattern, replace_uid, content)
        
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        return True, f"Fixed {len(fake_uids)} UID(s)"
    except Exception as e:
        return False, f"Error: {str(e)}"

def is_valid_godot_uid(uid_string):
    """Check if a UID is a valid Godot-generated UID."""
    # Valid Godot UIDs are uid:// followed by base64 characters (hyphens allowed, no underscores)
    # They look like: uid://c8uv5gedq2vj0 or uid://ldfyr-van4u (alphanumeric + hyphens)
    uid_part = uid_string.replace('uid://', '')
    # Godot UIDs don't contain underscores (which are in our fake UIDs)
    # They may contain hyphens though
    return '_' not in uid_part

def main():
    files_to_fix = [
        "game/tests/gut_runner.tscn",
        "game/scripts/asset_generation/player_sprite_generator_runner.tscn",
        "game/features/cutscenes/binding_ward_failed.tscn",
        "game/features/cutscenes/calming_draught_failed.tscn",
        "game/features/cutscenes/divine_blood_cutscene.tscn",
        "game/features/cutscenes/epilogue.tscn",
        "game/features/cutscenes/reversal_elixir_failed.tscn",
        "game/features/cutscenes/sailing_final.tscn",
        "game/features/cutscenes/sailing_first.tscn",
        "game/features/cutscenes/scylla_petrification.tscn",
        "game/features/cutscenes/scylla_transformation.tscn",
        "game/features/farm_plot/farm_plot.tscn",
        "game/features/locations/daedalus_workshop.tscn",
        "game/features/locations/titan_battlefield.tscn",
        "game/features/minigames/herb_identification.tscn",
        "game/features/minigames/moon_tears_minigame.tscn",
        "game/features/minigames/moon_tear_single.tscn",
        "game/features/minigames/sacred_earth.tscn",
        "game/features/minigames/weaving_minigame.tscn",
        "game/features/npcs/aeetes.tscn",
        "game/features/npcs/circe.tscn",
        "game/features/npcs/daedalus.tscn",
        "game/features/npcs/hermes.tscn",
        "game/features/npcs/npc_base.tscn",
        "game/features/npcs/scylla.tscn",
        "game/features/player/player.tscn",
        "game/features/ui/crafting_controller.tscn",
        "game/features/ui/crafting_minigame.tscn",
        "game/features/ui/debug_hud.tscn",
        "game/features/ui/dialogue_box.tscn",
        "game/features/ui/inventory_panel.tscn",
        "game/features/ui/item_slot.tscn",
        "game/features/ui/loading_screen.tscn",
        "game/features/ui/notification_system.tscn",
        "game/features/ui/scene_test_a.tscn",
        "game/features/ui/scene_test_b.tscn",
        "game/features/ui/settings_menu.tscn",
        "game/features/world/boat.tscn",
        "game/features/world/house_door.tscn",
        "game/features/world/loom.tscn",
        "game/features/world/recipe_book.tscn",
        "game/features/world/sundial.tscn",
    ]
    
    project_root = r"C:\Users\Sam\Documents\GitHub\v2_heras_garden"
    
    fixed_count = 0
    errors = []
    skipped = []
    
    print("=" * 60)
    print("Godot UID Fix Tool")
    print("=" * 60)
    print()
    
    for relative_path in files_to_fix:
        full_path = os.path.join(project_root, relative_path)
        print(f"Processing: {relative_path}")
        
        if not os.path.exists(full_path):
            errors.append(f"File not found: {relative_path}")
            continue
        
        success, message = fix_uid_in_file(full_path)
        if success:
            fixed_count += 1
            print(f"  [OK] {message}")
        else:
            if "No fake UIDs" in message:
                skipped.append(f"{relative_path}: {message}")
                print(f"  [SKIP] {message}")
            else:
                errors.append(f"{relative_path}: {message}")
                print(f"  [ERR] {message}")
    
    print()
    print("=" * 60)
    print("RESULTS")
    print("=" * 60)
    print(f"Files fixed: {fixed_count}/{len(files_to_fix)}")
    print(f"Files skipped: {len(skipped)}")
    print(f"Errors: {len(errors)}")
    
    if errors:
        print()
        print("ERRORS:")
        for err in errors:
            print(f"  [ERR] {err}")
    
    if skipped:
        print()
        print("SKIPPED (no fake UIDs):")
        for skip in skipped:
            print(f"  [SKIP] {skip}")
    
    print()
    print("Done!")

if __name__ == "__main__":
    main()
