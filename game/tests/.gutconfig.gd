# GUT Configuration for headless testing
# Run with: godot --headless -s addons/gut/gut_cmdln.gd -g gutter_options.gut

# Test directories
directories = ["res://game/tests/gut_comparison"]

# Output options
log_level = 3
should_exit = true
disable_colors = false

# Test options
include_subdirectories = true
double_strategy = SCRIPT_ONLY
