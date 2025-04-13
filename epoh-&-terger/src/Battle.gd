extends Control

signal textbox_closed

@export var enemy: Resource = null

var current_player_health
var current_enemy_health = 0
var is_defending = false

func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyContainer/Enemy.texture = enemy.texture
	
	current_player_health = State.current_health
	current_enemy_health = enemy.health
	
	$Textbox.hide()
	$ActionsPanel.hide()
	
	display_text("Are you scared? Don't worry, \n I won't bite, unlike other ghost. \n I am Terger.")
	await self.textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	State.set_player_health(health)
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").text = "HP: %d/%d" % [health, max_health]

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.text = text

func enemy_turn():
	display_text("Terger launches at you fiercely!")
	await self.textbox_closed
	
	if is_defending:
		is_defending = false
		$AnimationPlayer.play("mini_shake")
		await $AnimationPlayer.animation_finished
		display_text("You defended successfully!")
		await self.textbox_closed
	else:
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		display_text("Terger dealt %d damage!" % enemy.damage)
		await self.textbox_closed
		if(current_player_health == 0):
			get_tree().change_scene_to_file(str("res://scenes/GameOver.tscn"))
	$ActionsPanel.show()

func _on_Run_pressed():
	display_text("You want to nag her.")
	await self.textbox_closed

	# Adjust enemy color modulation based on damage
	var modulate_delta = State.damage / 255.0
	var c = $EnemyContainer/Regret2.modulate
	#var new_r = clamp(c.r - modulate_delta, 0.0, 1.0)
	#var new_g = clamp(c.g - modulate_delta, 0.0, 1.0)
	var new_b = clamp(c.b - modulate_delta, 0.0, 1.0)
	var new_color = Color(c.r, c.g, new_b, c.a)
	$EnemyContainer/Regret2.modulate = new_color

	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You successfully cover your ears.")
	await self.textbox_closed

	# Check win condition
	validation(c.r,c.g,new_b)

	enemy_turn()

func _on_Attack_pressed():
	display_text("You don't want to hear anything from her.")
	await self.textbox_closed

	# Adjust enemy color modulation based on damage
	var modulate_delta = State.damage / 255.0
	var c = $EnemyContainer/Regret2.modulate
	var new_r = clamp(c.r - modulate_delta, 0.0, 1.0)
	#var new_g = clamp(c.g - modulate_delta, 0.0, 1.0)
	#var new_b = clamp(c.b - modulate_delta, 0.0, 1.0)
	var new_color = Color(new_r, c.g, c.b, c.a)
	$EnemyContainer/Regret2.modulate = new_color

	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You successfully cover your ears.")
	await self.textbox_closed

	# Check win condition
	validation(new_r,c.g,c.b)

	enemy_turn()

func validation(new_r, new_g, new_b):
	if (new_r <= 0.01 and new_g <= 0.01 and new_b <= 0.01) or \
	   (new_r >= 0.99 and new_g >= 0.99 and new_b >= 0.99):
		display_text("Terger was defeated!")
		await self.textbox_closed
		
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(0.25).timeout
		Global.delete_enemy = true
		get_tree().change_scene_to_file("res://Level.tscn")
	
func _on_Defend_pressed():
	display_text("You ignore her.")
	await self.textbox_closed

	# Adjust enemy color modulation based on damage
	var modulate_delta = State.damage / 255.0
	var c = $EnemyContainer/Regret2.modulate
	#var new_r = clamp(c.r - modulate_delta, 0.0, 1.0)
	var new_g = clamp(c.g - modulate_delta, 0.0, 1.0)
	#var new_b = clamp(c.b - modulate_delta, 0.0, 1.0)
	var new_color = Color(c.r, new_g, c.b, c.a)
	$EnemyContainer/Regret2.modulate = new_color

	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished
	
	display_text("You successfully cover your ears.")
	await self.textbox_closed

	# Check win condition
	validation(c.r,new_g,c.b)

	enemy_turn()
	#is_defending = true
	#
	#display_text("You prepare defensively!")
	#await self.textbox_closed
	#
	#await get_tree().create_timer(0.25).timeout
	#
	#enemy_turn()
