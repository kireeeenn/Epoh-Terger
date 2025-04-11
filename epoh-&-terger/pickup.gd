extends LinkButton

@onready var interaction_ui = get_tree().get_root().get_node("Level/Player/Interaction Choices")
# Called when the node enters the scene tree for the first time.
func _on_link_button_pressed():
	var item = get_node("/root/Level/Coin")
	item.visible = false
	interaction_ui.visible = false
	Global.wins +=1 
