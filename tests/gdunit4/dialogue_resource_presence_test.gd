extends GdUnitTestSuite

func test_dialogue_resources_exist_for_npc_routes() -> void:
	var dialogue_ids = [
		"quest1_start",
		"quest2_start",
		"quest3_start",
		"quest4_start",
		"quest5_start",
		"quest6_start",
		"quest7_start",
		"quest8_start",
		"quest9_start",
		"quest10_start",
		"quest11_start",
		"act1_herb_identification",
		"act1_extract_sap",
		"act1_confront_scylla",
		"act2_farming_tutorial",
		"act2_calming_draught",
		"act2_reversal_elixir",
		"act2_daedalus_arrives",
		"act2_binding_ward",
		"act3_sacred_earth",
		"act3_moon_tears",
		"act3_final_confrontation"
	]

	for dialogue_id in dialogue_ids:
		var path = "res://game/shared/resources/dialogues/%s.tres" % dialogue_id
		var data = load(path) as DialogueData
		assert_that(data).is_not_null()
