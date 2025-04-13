extends Button

@onready var mission = get_tree().get_root().get_node("Level/Mission")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_pressed() -> void:
	mission.visible= !mission.visible
