extends CharacterBody2D
var speed = 10


func _physics_process(delta):
	if Input.is_action_pressed("up"):
		velocity.y -= speed
	if Input.is_action_pressed("down"):
		velocity.y += speed
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	if ! Input.is_action_pressed("right") && ! Input.is_action_pressed("left") && ! Input.is_action_pressed("down") && ! Input.is_action_pressed("up"):
		velocity = Vector2(0,0)
	move_and_slide()
