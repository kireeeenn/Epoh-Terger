extends CharacterBody2D

@export var move_interval: float = 1.0 # seconds between steps
@export var tile_size: int = 64
@export var chase_range: float = 400.0 # in pixels (optional)

var move_timer: float = 0.0
var player: CharacterBody2D

func _ready():
	player = get_parent().get_node("Player") # Adjust path if needed

func _physics_process(delta): # switched from _process to _physics_process
	if not player:
		return

	move_timer += delta

	var distance_to_player = position.distance_to(player.position)
	if distance_to_player > chase_range:
		return

	if move_timer >= move_interval:
		move_timer = 0.0
		move_one_tile_towards_player()

func move_one_tile_towards_player():
	var direction = (player.position - position).normalized()
	var step_vector = Vector2.ZERO

	# Move in cardinal direction closest to player
	if abs(direction.x) > abs(direction.y):
		step_vector.x = sign(direction.x) * tile_size
	else:
		step_vector.y = sign(direction.y) * tile_size

	var motion = step_vector
	var collision = move_and_collide(motion)

	if collision:
		if collision.get_collider().is_in_group("Player"):
			print("Enemy hit the Player!")
			# You can add life reduction or game over trigger here
