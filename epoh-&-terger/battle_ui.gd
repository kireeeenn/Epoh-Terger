extends Control

signal action_selected(action: String)

func _ready():
	$VBoxContainer/AttackButton.pressed.connect(self._on_attack_pressed)
	$VBoxContainer/ListenButton.pressed.connect(self._on_listen_pressed)
	$VBoxContainer/HugButton.pressed.connect(self._on_hug_pressed)

func _on_attack_pressed():
	emit_signal("action_selected", "attack")

func _on_listen_pressed():
	emit_signal("action_selected", "listen")

func _on_hug_pressed():
	emit_signal("action_selected", "hug")
