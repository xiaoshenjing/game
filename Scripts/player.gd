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

	position += vel * delta

	var half_size := Vector2.ZERO
	var cs := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if cs and cs.shape is RectangleShape2D:
		half_size = (cs.shape as RectangleShape2D).size * 0.5

	var rect := get_viewport().get_visible_rect()
	global_position = global_position.clamp(rect.position + half_size, rect.end - half_size)
