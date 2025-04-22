extends CharacterBody2D

const SPEED = 70
const DASH = 500 #change to 240 or less

var input_direction: get =_get_input_direction
var sprite_direction = "Down": get = _get_sprite_direction
var dash_velocity := 0.0
var tween: Tween
var ui_left = ("ui_left")
var ui_right = ("ui_right")
var ui_up = ("ui_up")
var ui_down = ("ui_down")

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
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
	
	set_animation("Walk")
	if Input.is_action_pressed("ui_accept"):
		set_animation("Dash")

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
