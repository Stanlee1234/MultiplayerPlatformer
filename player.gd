extends CharacterBody2D

const SPEED = 150.0
const CROUCH_SPEED = 75.0
const ROLL_SPEED = 200.0
const JUMP_VELOCITY = -350.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var is_rolling: bool = false
var double_jump_available: bool = false

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
			sprite.modulate = Color(0.78, 0.259, 0.468, 1.0) 
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
	
	# Reset double jump when on the floor
	if is_on_floor():
		double_jump_available = true

	# 2. Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 3. Handle Jump & Double Jump
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif double_jump_available:
			velocity.y = JUMP_VELOCITY
			double_jump_available = false # Consume the double jump
			
			# Force the animation to restart for the mid-air jump
			sprite.stop() 
			sprite.play("jump_spin")

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
	update_animations(direction, is_crouching)


func update_animations(direction: float, is_crouching: bool) -> void:
	if not is_on_floor():
		if velocity.y < 0:
			# If they used the double jump, show the spin. Otherwise, normal jump.
			if not double_jump_available:
				sprite.play("jump_spin")
			else:
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
