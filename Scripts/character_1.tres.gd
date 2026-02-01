extends CharacterBody2D
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const KNOCKBACK_STR = 150.0
const KNOCKBACK_DAMP = 1200.0
const COOLDOWN_TIME = 3.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var GameManager: Node
var cooldown := 0.0
var player1 = 2
var knockback_vel = Vector2.ZERO

@onready var audio_player = $PlayerHitbox/CollisionSound
@onready var player_select = $PlayerSwitch

func _physics_process(delta: float) -> void:
	if cooldown > 0:
		cooldown -= delta
		GameManager.set_timer_1(3 - cooldown)
	
	# Handle the "MASK" by displaying a new animation based 
	# on a button press
	if cooldown <= 0:
		if Input.is_action_just_pressed("ATKey1"):
			animated_sprite.play("Rock")
			if player1 != 1:
				var audio_stream = load("res://Assets/Sounds/Selection/RockSelect.wav")
				player_select.stream = audio_stream
				player_select.play()
				cooldown = COOLDOWN_TIME
			player1 = 1
			
		if Input.is_action_just_pressed("ATKey2"):
			animated_sprite.play("Paper")
			if player1 != 2:
				var audio_stream = load("res://Assets/Sounds/Selection/PaperSelect.wav")
				player_select.stream = audio_stream
				player_select.play()
				cooldown = COOLDOWN_TIME
			player1 = 2
			
		if Input.is_action_just_pressed("ATKey3"):
			animated_sprite.play("Scissors")
			if player1 != 3:
				var audio_stream = load("res://Assets/Sounds/Selection/ScissorsSelect.wav")
				player_select.stream = audio_stream
				player_select.play()
				cooldown = COOLDOWN_TIME
			player1 = 3
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("P1Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Jump.play()
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("P1Left", "P1Right")
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor() and Input.is_action_pressed("P1Right"):
		$Run.play()
		if not is_on_floor():
			$Run.stop()
	if Input.is_action_just_released("P1Right"):
		$Run.stop()
		
	if is_on_floor() and Input.is_action_pressed("P1Left"):
		$Run.play()
		if not is_on_floor():
			$Run.stop()
	if Input.is_action_just_released("P1Left"):
			$Run.stop()
			
	# Handle Knockbackd
	velocity += knockback_vel
	knockback_vel = knockback_vel.move_toward(Vector2.ZERO, KNOCKBACK_DAMP * delta)
	
	move_and_slide()
	
	# After move and slide - you will have a list of collisions
	for index in range (get_slide_collision_count()):
		# Check each collision
		var collision = get_slide_collision(index)
		# Check the OTHER
		var other = collision.get_collider()
		# Check if in group Players
		if other.is_in_group("Players"):
			print("Touched Player")


func _on_player_hitbox_area_entered(area: Area2D) -> void:
	# gets other CharacterBody2d
	var other = area.get_parent()
	# get a direction between the two
	var dir = (global_position - other.global_position).normalized()
	
	apply_knockback(dir)
	other.apply_knockback(-dir)
	if other.is_in_group("Players"):
		# They are same type
		if player1 == other.player2:
			print("Tie")
			GameManager.decreaseHP(2,2)
		
		# Player 1 wins
		elif (player1 == 1 && other.player2 == 3) || (player1 == 2 && other.player2 == 1) || (player1 == 3 && other.player2 == 2):
			print("Player1 Wins")
			GameManager.decreaseHP(1,5)
		# Player 2 wins
		else:
			print("Player2 Wins")
			GameManager.decreaseHP(5,1)
		print("Touched Player: ", area.name, " - Type: ", other.player2)
		
		if player1 == 1:
			if other.player2 == 1:
				var audio_stream = load("res://Assets/Sounds/Collision/2RocksCollide3wav.wav")
				audio_player.stream = audio_stream
				audio_player.play()
			if other.player2 == 2:
				var audio_stream = load("res://Assets/Sounds/Collision/RockPaperwav.wav")
				audio_player.stream = audio_stream
				audio_player.play()
			if other.player2 == 3:
				var audio_stream = load("res://Assets/Sounds/Collision/RockScissors.wav")
				audio_player.stream = audio_stream
				audio_player.play()
				
		elif player1 == 2:
			if other.player2 == 1:
				var audio_stream = load("res://Assets/Sounds/Collision/RockPaperwav.wav")
				audio_player.stream = audio_stream
				audio_player.play()
			if other.player2 == 2:
				var audio_stream = load("res://Assets/Sounds/Collision/2PapersCollide.wav")
				audio_player.stream = audio_stream
				audio_player.play()
			if other.player2 == 3:
				var audio_stream = load("res://Assets/Sounds/Collision/ScissorsPaper.wav")
				audio_player.stream = audio_stream
				audio_player.play()
				
		elif player1 == 3:
			if other.player2 == 1:
				var audio_stream = load("res://Assets/Sounds/Collision/RockScissors.wav")
				audio_player.stream = audio_stream
				audio_player.play()
			if other.player2 == 2:
				var audio_stream = load("res://Assets/Sounds/Collision/ScissorsPaper.wav")
				audio_player.stream = audio_stream
				audio_player.play()
			if other.player2 == 3:
				var audio_stream = load("res://Assets/Sounds/Collision/2ScissorsCollide2.wav")
				audio_player.stream = audio_stream
				audio_player.play()
		
	pass # Replace with function body.

func apply_knockback(dir: Vector2):
	knockback_vel += dir * KNOCKBACK_STR 
