extends RayCast2D

var cursor = load("res://assets/placeholder/cursor_placeholder.png")
onready var lightFlair = $LightFlair
onready var detecArea = lightFlair.get_node("DetectionArea")
onready var laserLine = $Line2D
var flairRadius

var globalMousePos
var targetPos
var lightPos = Vector2(0,0)
var conePos

func _ready():
	enabled = true
	laserLine.clear_points()
	laserLine.add_point(Vector2(0,0), 0)
	laserLine.add_point(Vector2(0,0), 1)
	
	switchLight(false)
	
	flairRadius = (lightFlair.texture.get_width()/2)*lightFlair.texture_scale

	
func _process(delta):
	pass


func _physics_process(delta):
	globalMousePos = get_global_mouse_position()
	targetPos = globalMousePos - global_position
	cast_to = targetPos
	if is_colliding():
		targetPos = get_collision_point() - global_position
	targetPos += global_position
	if targetPos.y > 0:
		targetPos.y -= 1
	elif targetPos.y < 0:
		targetPos.y += 1
	lightFlair.global_position = targetPos
	setLine()
	
	
func setLine():
	laserLine.set_point_position(0, conePos.global_position-global_position)
	laserLine.set_point_position(1, lightFlair.position)
	
	
func startLight():
	switchLight(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	#set_physics_process(true)
	
	
func stopLight():
	switchLight(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#set_physics_process(false)


func switchLight(switchOn):
	lightFlair.visible = switchOn
	laserLine.visible = switchOn
	detecArea.monitoring = switchOn
	set_physics_process(switchOn)
	
