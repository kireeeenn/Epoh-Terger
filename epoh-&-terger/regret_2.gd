extends CharacterBody2D

@export var move_interval: float = 1.0 # seconds between steps
@export var tile_size: int = 64
@export var follow_range: float = 1000.0 # max distance to start moving
@export var stop_range: float = 400.0 # minimum distance to stop moving

var move_timer: float = 0.0
var player: CharacterBody2D

func _ready():
	player = get_parent().get_node("Player") # Adjust path if needed

func _physics_process(delta):
	if not player:
		return

	move_timer += delta

	var distance_to_player = position.distance_to(player.position)
	
	# Do nothing if too far or already close enough
	if distance_to_player > follow_range or distance_to_player < stop_range:
		return

	if move_timer >= move_interval:
		move_timer = 0.0
		move_one_tile_towards_player()

func move_one_tile_towards_player():
	var direction = (player.position - position).normalized()
	var step_vector = Vector2.ZERO

	# Move in cardinal direction (grid-like)
	if abs(direction.x) > abs(direction.y):
		step_vector.x = sign(direction.x) * tile_size
	else:
		step_vector.y = sign(direction.y) * tile_size

	var motion = step_vector
	move_and_collide(motion)
