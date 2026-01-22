#!/usr/bin/env -S godot --headless --script
## GUT Test Runner - Executes GUT tests from command line
## Usage: godot --headless --script res://game/tests/run_gut_tests.gd

extends Node

func _ready():
	# Load GUT addon
	var GutMain = load("res://addons/gut/addons/gut/gut.gd")
	var gut = GutMain.new()
	add_child(gut)

	# Configure GUT to run tests from command line
	gut.select_tests_from("res://game/tests/gut_comparison")
	gut.run_tests()

	# Exit after tests complete
	await gut.finished
	get_tree().quit()
