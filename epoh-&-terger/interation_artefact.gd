extends Area2D

@onready var interaction_ui = get_tree().get_root().get_node("Level/Player/Interaction Choices")
@onready var player = get_node("/root/Level/Player")

func _process(delta):
	if interaction_ui.visible:
		interaction_ui.position = player.position + Vector2(0, -50)

func _on_area_entered(body):
	if body.name == "Player":
		interaction_ui.visible = true

func _on_area_exited(body):
	if body.name == "Player":
		interaction_ui.visible = false
