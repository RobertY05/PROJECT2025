extends Actor

@export var speed := 300.0
@export var sprint_multiplier := 1.8

func _ready():
	health = 100
	friendly = true

func _physics_process(_delta : float):
	var acceleration = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		acceleration.y -= 1
	if Input.is_action_pressed("move_down"):
		acceleration.y += 1
	if Input.is_action_pressed("move_left"):
		acceleration.x -= 1
	if Input.is_action_pressed("move_right"):
		acceleration.x += 1
	
	acceleration = acceleration.normalized()
	acceleration *= speed
	if Input.is_action_pressed("sprint"):
		acceleration *= sprint_multiplier
	
	velocity += acceleration
	super(_delta)
