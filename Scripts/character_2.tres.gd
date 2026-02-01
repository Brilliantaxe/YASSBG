extends CharacterBody2D
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const KNOCKBACK_STR = 150.0
const KNOCKBACK_DAMP = 1200.0
const COOLDOWN_TIME = 3.0

@onready var animated_sprite2: AnimatedSprite2D = $AnimatedSprite2D
@export var GameManager: Node
var cooldown = 0.0
var player2 = 2
var knockback_vel = Vector2.ZERO

@onready var player_select = $PlayerSwitch

func _physics_process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta
		GameManager.set_timer_2(3 - cooldown)
		
	# Handle the "MASK" by displaying a new animation based 
	# on a button press
	if cooldown <= 0:
		if Input.is_action_pressed("ATKey7"):
			animated_sprite2.play("Rock")
			if player2 != 1:
				var audio_stream = load("res://Assets/Sounds/Selection/RockSelect.wav")
				player_select.stream = audio_stream
				player_select.play()
				cooldown = COOLDOWN_TIME
			player2 = 1
			
		if Input.is_action_pressed("ATKey8"):
			animated_sprite2.play("Paper")
			if player2 != 2:
				var audio_stream = load("res://Assets/Sounds/Selection/PaperSelect.wav")
				player_select.stream = audio_stream
				player_select.play()
				cooldown = COOLDOWN_TIME
			player2 = 2
			
		if Input.is_action_pressed("ATKey9"):
			animated_sprite2.play("Scissors")
			if player2 != 3:
				var audio_stream = load("res://Assets/Sounds/Selection/ScissorsSelect.wav")
				player_select.stream = audio_stream
				player_select.play()
				cooldown = COOLDOWN_TIME
			player2 = 3
	  
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("P2Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Jump.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("P2Left", "P2Right")
	if direction > 0:
		animated_sprite2.flip_h = false
	elif direction < 0:
		animated_sprite2.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor() and Input.is_action_pressed("P2Right"):
		$Run.play()
		if not is_on_floor():
			$Run.stop()
	if Input.is_action_just_released("P2Right"):
		$Run.stop()
		
	if is_on_floor() and Input.is_action_pressed("P2Left"):
		$Run.play()
		if not is_on_floor():
			$Run.stop()
	if Input.is_action_just_released("P2Left"):
			$Run.stop()
	# Handle Knockback
	velocity += knockback_vel
	knockback_vel = knockback_vel.move_toward(Vector2.ZERO, KNOCKBACK_DAMP * delta)
		
	move_and_slide()

func apply_knockback(dir: Vector2):
	knockback_vel += dir * KNOCKBACK_STR 
