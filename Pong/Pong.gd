extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screenSize
var padSize
var direction = Vector2(1.0, 0.0)

const INITIAL_BALL_SPEED = 80
var ballSpeed = INITIAL_BALL_SPEED
const PAD_SPEED = 150

func _process(delta):
	var ballPos = get_node("ball").get_pos()
	var leftRect = Rect2(get_node("left").get_pos() - padSize*0.5, padSize)
	var rightRect = Rect2(get_node("right").get_pos() - padSize*0.5, padSize)
	ballPos += direction * ballSpeed * delta
	
	#flip when touch floor or roof
	if ((ballPos.y < 0 and direction.y < 0) or (ballPos.y > screenSize.y and direction.y > 0)):
		direction.y =  -direction.y
		
	#filp , change direction and speed up when touch panel
	if ((leftRect.has_point(ballPos) and direction.x < 0) or (rightRect.has_point(ballPos) and direction.x > 0)):
		direction.x = -direction.x
		direction.y = randf()*2.0-1
		direction = direction.normalized()
		ballSpeed = ballSpeed * 1.1
	#check gameover
	if (ballPos.x < 0 or ballPos.x > screenSize.x):
		ballPos = screenSize*0.5
		ballSpeed = INITIAL_BALL_SPEED
		direction = Vector2(-1, 0)
		
	get_node("ball").set_pos(ballPos)
	
	#move left panel
	var leftPos = get_node("left").get_pos()
	if (leftPos.y > 0 and Input.is_action_pressed("left_move_up")):
		leftPos.y += -PAD_SPEED * delta
	if (leftPos.y < screenSize.y and Input.is_action_pressed("left_move_down")):
		leftPos.y += PAD_SPEED *delta
	get_node("left").set_pos(leftPos)
	
	#move right panel
	var rightPos = get_node("right").get_pos()
	if (rightPos.y > 0 and Input.is_action_pressed("right_move_up")):
		rightPos.y += -PAD_SPEED * delta
	if (rightPos.y < screenSize.y and Input.is_action_pressed("right_move_down")):
		rightPos.y += PAD_SPEED * delta
	get_node("right").set_pos(rightPos)
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	#pass
	screenSize = get_viewport_rect().size
	padSize = get_node("left").get_texture().get_size()
	set_process(true)
	
