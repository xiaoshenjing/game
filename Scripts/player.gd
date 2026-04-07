extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:
	var vel = Vector2.ZERO
	if Input.is_action_pressed("down"):
		vel.y += SPEED
	if Input.is_action_pressed("up"):
		vel.y -= SPEED
	if Input.is_action_pressed("right"):
		vel.x += SPEED
	if Input.is_action_pressed("left"):
		vel.x -= SPEED

	position += vel * delta;
