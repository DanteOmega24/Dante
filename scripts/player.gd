extends CharacterBody2D

const SPEED = 100
const DASH = 240 #change to 240 or less


var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 200 #change to 170 aprox
var player_alive = true


var input_direction: get =_get_input_direction
var sprite_direction = "Down": get = _get_sprite_direction
var dash_velocity := 0.0
var tween: Tween
var ui_left = ("ui_left") 
var ui_right = ("ui_right")
var ui_up = ("ui_up")
var ui_down = ("ui_down")

var attack_ip = false
var dash = DASH
var dashTimeout = 0


var isAttackTriggered = 0

@onready var sprite = $AnimatedSprite2D


func _physics_process(_delta):
	
	velocity = input_direction * SPEED
	if Input.is_action_pressed("ui_accept"):
		dash_velocity = DASH
		if tween:
			tween.stop()
		tween = create_tween()
		tween.tween_property(self, "dash_velocity", 0, 0.3).set_ease(Tween.EASE_OUT)
	
	var direction_x = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	var direction_y = -int(Input. is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down")) 
	
	if direction_x:
		velocity.x = direction_x * (SPEED + dash_velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction_y:
		velocity.y = direction_y * (SPEED + dash_velocity)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
	if isAttackTriggered == 0:
		set_animation("Walk")
		if Input.is_action_pressed("ui_accept"):
			set_animation("Dash")

	
	enemy_attack()
	attack()
	update_health()
	game_over()

	
	if health <= 0:
		player_alive = false #add end screen
		health = 0
		print("player has been killed")
		self.queue_free()
	

func set_animation(animation):
	var direction = "Left" if sprite_direction in ["Left"] else sprite_direction
	sprite.play(animation + direction)
	
	
func _get_input_direction():
	var x = -int(Input.is_action_pressed("ui_left")) + int(Input.is_action_pressed("ui_right"))
	var y = -int(Input. is_action_pressed("ui_up")) + int(Input.is_action_pressed("ui_down")) 
	input_direction = Vector2(x,y).normalized()
	return input_direction

func _get_sprite_direction():
	match input_direction:
		Vector2.LEFT:
			sprite_direction = "Left"
		Vector2.RIGHT:
			sprite_direction = "Right"
		Vector2.UP:
			sprite_direction = "Up"
		Vector2.DOWN:
			sprite_direction = "Down"
	return sprite_direction

func player():
	pass

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true
		
	
func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false
		

func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	var direction = "Left" if sprite_direction in ["Left"] else sprite_direction
	
	if Input.is_action_just_pressed("attack"):
		match input_direction:
			Vector2.DOWN:
				sprite_direction = "Down"
				if Input.is_action_just_pressed("attack"):
					$AnimatedSprite2D.play("AttackDown", 1)
					while $AnimatedSprite2D.is_playing() == true:
						isAttackTriggered = 1
						await get_tree().create_timer(.25).timeout
						$AnimatedSprite2D.stop()
					isAttackTriggered = 0
					global.player_current_attack = true
					attack_ip = true
					$deal_attack_timer.start()
					print("down")
			Vector2.UP:
				sprite_direction = "Up"
				if Input.is_action_just_pressed("attack"):
					$AnimatedSprite2D.play("AttackUp", 1)
					while $AnimatedSprite2D.is_playing() == true:
						isAttackTriggered = 1
						await get_tree().create_timer(.25).timeout
						$AnimatedSprite2D.stop()
					isAttackTriggered = 0
					global.player_current_attack = true
					attack_ip = true
					$deal_attack_timer.start()
					print("up")
			Vector2.LEFT:
				sprite_direction = "Left"
				if Input.is_action_just_pressed("attack"):
					$AnimatedSprite2D.play("AttackLeft", 1)
					while $AnimatedSprite2D.is_playing() == true:
						isAttackTriggered = 1
						await get_tree().create_timer(.25).timeout
						$AnimatedSprite2D.stop()
					isAttackTriggered = 0
					global.player_current_attack = true
					attack_ip = true
					$deal_attack_timer.start()
					print("left")
			Vector2.RIGHT:
				sprite_direction = "Right"
				if Input.is_action_just_pressed("attack"):
					$AnimatedSprite2D.play("AttackRight", 1)
					while $AnimatedSprite2D.is_playing() == true:
						isAttackTriggered = 1
						await get_tree().create_timer(.25).timeout
						$AnimatedSprite2D.stop()
					isAttackTriggered = 0
					global.player_current_attack = true
					attack_ip = true
					$deal_attack_timer.start()
					print("right")
		return sprite_direction


func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false



func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	if health >= 200:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regin_timer_timeout() -> void:
	if health < 200:
		health = health + 20
		if health > 200:
			health = 200
	if health == 0:
		health = 0

func game_over():
	if health == 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
