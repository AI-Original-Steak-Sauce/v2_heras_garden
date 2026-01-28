@tool
extends EditorScript

func _run():
    var files = [
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
    
    print("\n=== Results ===")
    print("Fixed: " + str(fixed_count) + "/" + str(len(files)))
    if errors.size() > 0:
        print("\nErrors:")
        for err in errors:
            print("  ✗ " + err)
