extends KinematicBody2D


export (PackedScene) var rayCastTemplate
var player = null
var drone = null
var headPosition
var targetPos
var attackingSpeed = 160
export (float) var recoveringSpeed = 160
export (float) var idleSpeed = 120
export (float) var fleeSpeed = 80
export (float) var idlePathTime = 6
export (float) var idlePathTimeFast = 4
export (float) var fleeDur = 6
var angularSpeedIdle = TAU
var angularSpeedRecovering = TAU
var angularSpeedFleeing = TAU
var dynamicSpeed
#raycast cone
export var angle_cone_of_vision = deg2rad(360.0)
export var max_view_distance = 100.0
export var angle_between_rays = deg2rad(45.0)

var velocity: Vector2 = Vector2.ZERO 
var move_direction = Vector2.UP
var angle: float = 0.0
var nextPoint: Vector2 = Vector2.ZERO
var currentPoint: Vector2 = Vector2.ZERO
var moveVector = Vector2(0,0)
var moveVectorOld
var idlePathLength
var idlePathPoints: Array = []
var path: Array = []
var normal
var levelNavigation: Navigation2D = null
onready var idlePathCurve = $Path2D.get_curve()
var startPoint
var t = 0.0
var i = 1
var angleToPlayer
var doRotate
var frameRot
var fleeConeAngle = PI/2
var rotFinished = false
var rays = []
var avgRadius
var fleeNormal
var moveVec
var fleeEndPoint
var clampedPos
onready var ray = $RayCastMid
onready var rayTurn = $RayCast2DTurn
onready var rayLeft = $RayCast2DLeft
onready var rayRight = $RayCast2DRight
var colNormal
var rot = 2
var setClass = false
var findingAngle

var distortRange = 0.3
var timeD = 0.5
var distortion = 0.0
var fromD = distortion
var toD = distortion
var segD
var closeToAttack = false

var shading = false

enum States{
	IDLE = 0,
	ATTACKING = 1,
	CLAMPING = 2,
	RECOVERING = 3,
	FLEEING = 4
}
var State = States.IDLE

# Called when the node enters the scene tree for the first time.
func _ready():
	avgRadius = ($CheckForRadiusCollision/CollisionShape2D.shape.extents.x+$CheckForRadiusCollision/CollisionShape2D.shape.extents.y)/2
	setIdle()
	setIdleCurve()
	
	startPoint = idlePathPoints[0]
	global_position = startPoint
	nextPoint = idlePathPoints[1]
	rotation = Vector2.UP.rotated(rotation).angle_to(nextPoint-global_position)
	
	shading = false
	setShader("distortion", distortion)
	$Timer.paused = true
	print("timer paused")
	

func _process(delta):
	if setClass == false:
		setClass = true
	

func _physics_process(delta):
	#get_parent().get_node("Button").text = str(States.keys()[State]) + "--distort" + str(distortion)
	#print(shading)
	if shading:
		distort(delta)
	elif !shading && distortion != toD:
		distortEnd(delta)
			
	normal = Vector2.UP.rotated(rotation)
	
	if State == States.ATTACKING:
		navigateToPlayer(delta, player.global_position + headPosition)
	elif State == States.IDLE:
		idleMovement2(delta)	
	elif State == States.CLAMPING:
		player.clamped = true
		global_position = player.global_position + headPosition + clampedPos
	elif State == States.FLEEING:
		fleeing(delta)
	elif State == States.RECOVERING:
		navigateToStart(delta)
	

func navigateToPlayer(delta,pos):
	angle = normal.angle_to(pos-global_position)
	self.rotate(angle)
	global_position = global_position.move_toward(pos, delta * attackingSpeed)
	if (global_position-pos).length() <= 30:
		setClamping()
		clampedPos = global_position-pos
	else:
		moveVector = pos-global_position
		
		
func navigateToStart(delta):
	movePerFrame(delta,dynamicSpeed ,recoveringSpeed, angularSpeedRecovering)
	if global_position == startPoint:
		i = 0
		nextPoint = idlePathPoints[i]
		setIdle()
		endDistortion()
		
		
func playerInRange(body):
	if player == null:
		player = body
		headPosition = player.get_node("HeadPosition").position
		player.connect("dead", self, "setRecovering")
	if State == States.IDLE:
		setAttacking()
	else:
		closeToAttack = true


func idleMovement2(delta):
	if global_position == nextPoint:
		setMovementData(delta)
	movePerFrame(delta, dynamicSpeed, idleSpeed, angularSpeedIdle)


func fleeing(delta):
	movePerDir(delta, fleeSpeed, angularSpeedFleeing)


func setIdleCurve() -> void:
	idlePathPoints.clear()
	for s in range(0,idlePathCurve.get_point_count()):
		idlePathPoints.append(idlePathCurve.get_point_position(s)*scale.x+global_position)



func setIdle():
	if closeToAttack:
		setAttacking()
	else:
		print("idle")
		State = States.IDLE
		setRays(false)
		$AnimationPlayer.play("idle")


func setAttacking():
	print("attack")
	State = States.ATTACKING
	setRays(true)
	$AnimationPlayer.play("attacking")


func setClamping():
	print("clamping")
	State = States.CLAMPING
	$AnimationPlayer.play("latched")
	deathTimer()
	

func deathTimer():
	player.deathFadeOut(true)
	$Timer.paused = false
	$Timer.start()
	print("timer started")
	

func setRecovering():
	print("recovering")
	State = States.RECOVERING
	if player != null:
		if player.clamped == true:
			player.clamped = false
			player.deathFadeOut(false)
			$Timer.paused = true
			print("timer paused")
	setDistortion()
	nextPoint = startPoint
	$AnimationPlayer.play("fleeing")

	
	
func setFleeing(fleeDir):
	print("fleeing")
	State = States.FLEEING
	setRays(true)
	findingAngle=true
	fleeTimer(fleeDur)
	angleToPlayer = drone.global_position - global_position
	var angleDiff = angleToPlayer.angle_to(fleeDir)
	if angleDiff >= 0 && angleDiff <= fleeConeAngle:
		fleeDir = Vector2(-fleeDir.y, fleeDir.x).normalized()
	elif angleDiff < 0 && angleDiff >= -fleeConeAngle:
		fleeDir = Vector2(fleeDir.y, -fleeDir.x).normalized()
	else:
		fleeDir = fleeDir.normalized()
	fleeNormal = fleeDir
	setDistortion()
	$AnimationPlayer.play("fleeing")
		
		
func fleeTimer(delay):
	yield(get_tree().create_timer(delay),"timeout")
	setRecovering()
	setRays(false)


func setRays(value):
	ray.enabled = value
	rayTurn.enabled = value
	rayRight.enabled = value
	rayLeft.enabled = value


func inLightRange(mVector, droneFlare):
	if drone == null:
		drone = droneFlare
	print("hit")
	if State == States.CLAMPING:
		setRecovering()
	elif State == States.IDLE:
		setFleeing(mVector)	
	elif State == States.ATTACKING:
		setRecovering()
	elif State == States.RECOVERING:
		setFleeing(mVector)
	elif State == States.FLEEING:
		setFleeing(mVector)
		
func movePerFrame(delta, dynamicSpeed, speed, angularSpeed):
	moveVector = nextPoint - global_position
	angle = normal.angle_to(moveVector)
	angle = stepify(angle,0.0001)
	if angle == 0:
		frameRot = 0
	elif abs(angle) <= abs(angularSpeed*delta):
		frameRot = angle
	else:
		if angle >= 0:
			frameRot = angularSpeed*delta
		elif angle < 0:
			frameRot = -angularSpeed*delta
	#global_position = global_position.move_toward(nextPoint, delta * speed)
	self.rotate(frameRot)
	if moveVector.length() <= speed * delta:
		global_position = nextPoint
	else:
		global_position = global_position + normal.rotated(frameRot) * speed * delta
		#else:
		#	global_position = global_position + normal.rotated(frameRot) * dynamicSpeed * delta
	
	
func setMovementData(delta):
	if idlePathPoints.size()-1 == i:
		i = 0
	else:	
		i += 1
	nextPoint = idlePathPoints[i]
	

func movePerDir(delta, speed, angularSpeed):
	if findingAngle:
		angle = normal.angle_to(fleeNormal)
		if rayTurn.enabled:
			if angle >= 0:
				rayTurn.cast_to = normal.rotated(sin(abs(angle)/2)) * ((fleeSpeed*delta*ceil(abs(angle)/(angularSpeed*delta)))/(4*sin(sin(abs(angle)/2)))+$CheckForRadiusCollision/CollisionShape2D.shape.extents.y)
			else:
				rayTurn.cast_to = normal.rotated(-sin(abs(angle)/2)) * ((fleeSpeed*delta*ceil(abs(angle)/(angularSpeed*delta)))/(4*sin(sin(abs(angle)/2)))+$CheckForRadiusCollision/CollisionShape2D.shape.extents.y)
			#rayTurn.enabled=false
		if ray.is_colliding() == false && rayTurn.is_colliding() == false:
			if abs(angle) <0.001:
				findingAngle = false
				rot = 0
			elif angle > 0:
				rot = 1
			else:
				rot = -1	
		else:
			findingAngle = false
			if ray.is_colliding() == true:
				colNormal = ray.get_collision_normal()
			else:
				colNormal = rayTurn.get_collision_normal()
			angle = normal.angle_to(colNormal)
			if abs(angle) <0.001:
				rot = 0
			elif angle > 0:
				rot = 1
			else:
				rot = -1
	else:
		if ray.is_colliding():
			colNormal = ray.get_collision_normal()
		elif rayLeft.is_colliding():
			colNormal = rayLeft.get_collision_normal()
		elif rayRight.is_colliding():
			colNormal = rayRight.get_collision_normal()
		else:
			colNormal = normal
			
		angle = normal.angle_to(colNormal)
		if abs(angle) <0.001:
			rot = 0
		elif angle > 0:
			rot = 1
		else:
			rot = -1
	moveVector = normal.rotated(rot*angularSpeed*delta)
	self.rotate(rot*angularSpeed*delta)
	global_position = global_position + moveVector*speed*delta


func setDistortion():
	fromD = distortion
	toD = distortRange
	shading = true

func endDistortion():
	fromD = distortion
	toD = 0
	shading = false


func distortEnd(delta):
	segD = (abs(fromD-toD)*delta)/timeD
	distortion -= segD
	if distortion <= toD:
		distortion = toD
	setShader("distortion", distortion)

func distort(delta):
	segD = (abs(fromD-toD)*delta)/timeD
	if fromD <= toD:
		distortion += segD
		if distortion >= distortRange:
			distortion = distortRange
			toD = 0.0
			fromD = distortion
	elif fromD > toD:
		distortion -= segD
		if distortion <= 0.0:
			distortion = 0.0
			toD = distortRange
			fromD = distortion
	setShader("distortion", distortion)
	

func setShader(name, value):
	$Latched.material.set_shader_param(name, value)
	$Idle.material.set_shader_param(name, value)
	$Fleeing.material.set_shader_param(name, value)
	#$FleeingEyes.material.set_shader_param(name, value)
	$Attacking.material.set_shader_param(name, value)


func _on_Timer_timeout():
	player.death()
	$Timer.paused = true
