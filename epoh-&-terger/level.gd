extends Node2D

func _ready() -> void:
	print("Welcome.")

func _process(delta: float) -> void:
	check_global_variables()

func check_global_variables():
	# Example checks — customize this as needed
	if Global.delete_enemy == true and Global.current_enemy:
		Global.current_enemy.hide()  # Or use queue_free() to delete it
		Global.delete_enemy = false  # Reset the flag after handling
		Global.current_enemy = null  # Clear the reference
	if Global.wins == 6:
		get_tree().change_scene_to_file(str("res://scenes/Win.tscn"))
	# You can add more logic to monitor other global states
