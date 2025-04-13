extends CharacterBody2D

@export var speed: int = 400
var can_take_damage = true
@export var damage_cooldown = 1.0 # seconds
var damage_timer = 0.0
var interaction_open = false

func _ready():
	$EnemyDetector.body_entered.connect(_on_enemy_detected)

func _on_enemy_detected(body):
	if body.is_in_group("enemies"):
		Global.current_enemy = body
		print("Collided with enemy:", body.name)


func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left") :
		velocity.x -= speed
	if Input.is_action_pressed("ui_down") :
		velocity.y += speed
	if Input.is_action_pressed("ui_up"):
		velocity.y -= speed


func _physics_process(delta):
	get_input()
	move_and_slide()
	# Handle damage cooldown
	if not can_take_damage:
		damage_timer += delta
		if damage_timer >= damage_cooldown:
			can_take_damage = true
			damage_timer = 0.0

	# Collision detection
	if can_take_damage:
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var object_name = collision.get_collider().name
			print("Collided with: ", object_name)
			if collision.get_collider().is_in_group("Assertive_Enemy") or collision.get_collider().is_in_group("PassiveEnemy"):
				print("Player hit enemy!")
				Global.lives -= 1
				if Global.lives == 0:
					get_tree().change_scene_to_file(str("res://scenes/GameOver.tscn"))
				can_take_damage = false
				break # avoid double hit in same frame
			elif collision.get_collider().is_in_group("Passive_Enemy"):
				Global.current_enemy=object_name
				get_tree().change_scene_to_file(str("res://src/Battle.tscn"))


func _process(_delta):
	if velocity.x != 0:
		$Animator.play("Walk")
	else:
		$Animator.play("Idle")

	if velocity.x != 0:
		if velocity.x > 0:
			$Sprite2D.flip_h = false
		else:
			$Sprite2D.flip_h = true
