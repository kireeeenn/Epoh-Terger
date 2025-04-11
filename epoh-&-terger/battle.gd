extends Node2D

var player
var enemy
var turn = "player"
var enemyHP = 6
var colors = ["red", "green", "blue", "orange", "purple"]

func _ready():
	randomize()
	$BattleUI.connect("action_selected", self._on_action_selected)
	update_ui()

func _on_action_selected(action: String):
	if turn != "player":
		return

	match action:
		"attack":
			var damage = calculate_damage("red", colors)
			enemyHP -= damage
			print("You attacked the enemy for %d damage!" % damage)
		"listen":
			var damage = calculate_damage("blue", colors)
			enemyHP -= damage
			print("You try to listen... Maybe you'll learn something.")
		"hug":
			var damage = calculate_damage("pink", colors)
			enemyHP -= damage
			print("You hug the enemy. It's awkward, but kind of sweet.")

	check_battle_end()
	turn = "enemy"
	call_deferred("_delayed_enemy_turn")

func _delayed_enemy_turn():
	# ✅ Replaces create_timer() safely
	await get_tree().process_frame
	enemy_turn()

func enemy_turn():
	if turn != "enemy":
		return

	var enemy_color = get_random_color()
	print("Enemy uses color: %s" % enemy_color)

	var damage = calculate_damage(enemy_color, "red") # Replace "red" with actual player color if you have one
	Global.lives -= damage
	print("Enemy attacked you for %d damage!" % damage)

	check_battle_end()
	turn = "player"

func get_random_color() -> String:
	return colors[randi() % colors.size()]

func calculate_damage(attacker_color, defender_color):
	var effectiveness = {
		"red": {"green": 2, "blue": 0.5},
		"green": {"blue": 2, "red": 0.5},
		"blue": {"red": 2, "green": 0.5},
	}
	var base_damage = 10
	var multiplier = effectiveness.get(attacker_color, {}).get(defender_color, 1)
	return base_damage * multiplier

func check_battle_end():
	if Global.lives <= 0:
		print("You lost!")
		get_tree().change_scene_to_file("res://GameOver.tscn")
	elif enemyHP <= 0:
		print("You won!")
		get_tree().change_scene_to_file("res://Level.tscn")

func update_ui():
	$CanvasLayer/GUI/VBoxContainer/PlayerHP.text = "Your HP: %d" % Global.lives
	$CanvasLayer/GUI/VBoxContainer/EnemyHP.text = "Enemy HP: %d" % enemyHP
