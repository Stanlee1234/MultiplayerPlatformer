extends CharacterBody2D

const SPEED = 150.0
const CROUCH_SPEED = 75.0
const ROLL_SPEED = 200.0
const JUMP_VELOCITY = -300.0
const WALL_SLIDE_SPEED = 100.0 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_rolling: bool = false
var is_wall_landing: bool = false
var was_on_wall: bool = false

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _ready() -> void:
	var camera = $Camera2D
	var player_id = name.to_int()
	
	sprite.animation_finished.connect(_on_sprite_animation_finished)
	
	# --- Multiplayer Visibility ---
	if is_multiplayer_authority():
		camera.make_current()
		z_index = 10
		if player_id == 1:
			sprite.modulate = Color(1.0, 0.85, 0.3) 
	else:
		camera.enabled = false
		z_index = 1
		if player_id == 1:
			sprite.visible = false
			set_collision_layer_value(2, false)
		else:
			sprite.modulate = Color(0.5, 0.5, 1.0, 0.6) 

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return 

	# 1. Rolling State Lock
	if is_rolling:
		if not is_on_floor():
			velocity += get_gravity() * delta
		move_and_slide()
		return

	var direction := Input.get_axis("left", "right")
	
	# Cancel wall landing early if we let go of the direction
	if not is_on_wall_only() or direction == 0:
		is_wall_landing = false

	# 2. Gravity & Wall Sliding
	if not is_on_floor():
		if is_on_wall_only() and velocity.y > 0 and direction != 0:
			velocity.y = WALL_SLIDE_SPEED 
		else:
			velocity += get_gravity() * delta

	# 3. Handle Jump
	if Input.is_action_just_pressed("up"):
		is_wall_landing = false 
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_on_wall_only():
			velocity.y = JUMP_VELOCITY
			velocity.x = get_wall_normal().x * SPEED * 2.0

	# 4. Handle Roll vs. Crouch Logic
	var is_crouching := false
	if direction != 0 and Input.is_action_just_pressed("down") and is_on_floor():
		is_rolling = true
		sprite.play("roll")
		velocity.x = direction * ROLL_SPEED
		move_and_slide()
		return 
	elif Input.is_action_pressed("down") and is_on_floor():
		is_crouching = true

	# 5. Normal Movement
	if direction:
		velocity.x = direction * (CROUCH_SPEED if is_crouching else SPEED)
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# --- Check for Wall Impact ---
	if is_on_wall_only() and not was_on_wall and velocity.y > 0 and direction != 0:
		is_wall_landing = true
		sprite.play("wall_land")

	update_animations(direction, is_crouching)
	was_on_wall = is_on_wall_only()


func update_animations(direction: float, is_crouching: bool) -> void:
	if is_wall_landing:
		return

	if not is_on_floor():
		if is_on_wall_only() and velocity.y > 0 and direction != 0:
			sprite.play("wall_slide")
		elif velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("jump_spin") 
	else:
		if is_crouching:
			if direction != 0:
				sprite.play("crouch_walk")
			else:
				sprite.play("crouch_idle")
		elif direction != 0:
			sprite.play("run")
		else:
			sprite.play("idle")


func _on_sprite_animation_finished() -> void:
	if sprite.animation == "roll":
		is_rolling = false 
	elif sprite.animation == "wall_land":
		is_wall_landing = false
