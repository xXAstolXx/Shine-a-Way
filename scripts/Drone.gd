extends KinematicBody2D

var cursor = load("res://assets/placeholder/cursor_placeholder.png")
export (float) var energy = 100
export (float) var maxEnergy = 100
export (float) var energyPerSec = 10
export (float) var energyPerSecReg = 5
export (float) var energyInitKill = 5
export (float) var speed = 150
export (float) var idleSpeed = 50
export (float) var startChaseLength = 100
var idleRadius = 100
var slowingSpeed
var isLoading = false
var droneArea = null
var chasing = false
var path
var nextPosition
var nextPositionLocal
var radiusDroneArea
var normal
var startPos
var dir
onready var droneCursor = load("res://assets/placeholder/cursor_placeholder.png")
onready var nav: Navigation2D = get_node("../Navigation2D")


func _ready():
	$MFLaser.conePos = $DroneBack/Position2D
	slowingSpeed = speed
	startPos = global_position
	setEnergyBar()
	
	
func _process(delta):
	if droneArea != null:
		adjustDrone()
		energy += energyPerSecReg * delta
		if Input.is_action_pressed("Mouse_Left") && energy > 0:
			if Input.is_action_just_pressed("Mouse_Left"):
				energy -= energyInitKill
				$MFLaser.startLight()
				if energy <= 0:
					$Audio_No_Energy.playing = true
			energy -= delta * energyPerSec
		if energy > maxEnergy:
			energy = maxEnergy
		if energy < 0:
			energy = 0
		if Input.is_action_just_released("Mouse_Left") || energy == 0:
			$MFLaser.stopLight()
		$ColorRect.material.set_shader_param("value", energy)
		$EnergyBar.material.set_shader_param("energy", energy)
	

func _physics_process(delta):
	if droneArea == null:
		idleMovement(delta)
	elif chasing == true:
		move(delta)
	else:
		if (droneArea.global_position - global_position).length() >= startChaseLength:
			chasing = true
			slowingSpeed = speed
			setDir()
		if global_position != nextPosition:
			global_position = global_position.move_toward(nextPosition, delta * slowingSpeed)
			slowingSpeed *= 0.95
	
	
func setDir():
	if (droneArea.global_position-global_position).x < 0:
		flip(true)
	if (droneArea.global_position-global_position).x > 0:
		flip(false)


func flip(value):
	$Drone.flip_h = value
	$EnergyBar.flip_h = value
	
func stopChase():
	if droneArea != null:
		#print("stop chasing drone area")
		chasing = false
		randomTarget()
	
	
func move(delta):
	path = nav.get_simple_path(global_position, droneArea.global_position, true)
	nextPosition = path[1] - global_position
	move_and_collide(nextPosition.normalized() * speed * delta)
	

func randomTarget():
	randomize()
	var angle = rad2deg(rand_range(0,2*PI))
	
	if angle >= 0 && angle < 90:
		normal = Vector2(sin(deg2rad(angle)),-cos(deg2rad(angle)))
	elif angle >= 90 && angle < 180:
		normal = Vector2(cos(deg2rad(angle-90)),sin(deg2rad(angle-90)))
	elif angle >= 180 && angle < 270:
		normal = Vector2(-sin(deg2rad(angle-180)),cos(deg2rad(angle-180)))
	elif angle >= 270 && angle < 360:
		normal = Vector2(-cos(deg2rad(angle-270)),-sin(deg2rad(angle-270)))
	#randomized local target position from the current drone position
	nextPosition = (normal * 0.75 * radiusDroneArea) + droneArea.global_position


func picked(player):
	if droneArea == null:
		$AnimationPlayer.play("picked")
		$Audio_Picked.playing = true
		droneArea = player.droneArea
		nextPosition = droneArea.global_position
		radiusDroneArea = droneArea.get_node("CollisionShape2D").shape.radius
		Input.set_custom_mouse_cursor(droneCursor, 0, Vector2( 32, 32 ))
func idleMovement(delta):
	var toCenter = false
	if global_position == startPos:
		randomize()
		var angle = rad2deg(rand_range(0,2*PI))
		var length = idleRadius*rand_range(0,1)
		
		if angle >= 0 && angle < 90:
			normal = Vector2(sin(deg2rad(angle)),-cos(deg2rad(angle)))
		elif angle >= 90 && angle < 180:
			normal = Vector2(cos(deg2rad(angle-90)),sin(deg2rad(angle-90)))
		elif angle >= 180 && angle < 270:
			normal = Vector2(-sin(deg2rad(angle-180)),cos(deg2rad(angle-180)))
		elif angle >= 270 && angle < 360:
			normal = Vector2(-cos(deg2rad(angle-270)),-sin(deg2rad(angle-270)))
		nextPosition = length*normal + global_position
	elif global_position == nextPosition:
		nextPosition = startPos
	global_position = global_position.move_toward(nextPosition, delta * idleSpeed)
	
func refillEnergy(energyAmount):
	energy += energyAmount
	if energy > maxEnergy:
		energy = maxEnergy
		
func upgradeMaxEnergy(energyAmount):
	maxEnergy += energyAmount
	$EnergyBar.material.set_shader_param("maxEnergy", maxEnergy)
	print("maxEnergy: ", maxEnergy)
	
	
func setEnergyBar():
	var width = $EnergyBar.get_rect().size.x
	var height = $EnergyBar.get_rect().size.y
	$EnergyBar.material.set_shader_param("startUV", ($EnergyBar/LeftCheck.position.x+width/2.0)/width)
	$EnergyBar.material.set_shader_param("endUV", ($EnergyBar/RightCheck.position.x+width/2.0)/width)
	$EnergyBar.material.set_shader_param("topUV", ($EnergyBar/TopCheck.position.y+height/2.0)/height)
	$EnergyBar.material.set_shader_param("botUV", ($EnergyBar/BotCheck.position.y+height/2.0)/height)
	$EnergyBar.material.set_shader_param("maxEnergy", maxEnergy)


func adjustDrone():
	$DroneBack.rotation = Vector2.UP.angle_to(get_global_mouse_position()-global_position)
