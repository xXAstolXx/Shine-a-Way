class_name Player
extends KinematicBody2D

export (PackedScene) var droneTemplate
export (float) var slow = 0.2
#export (int) var GRAVITY = 30
var velocity  = Vector2(0,0)
#export (float) var jumpForce = 800
var acceleration = 20
var maxSpeed = 300
var maxfallSpeed = 2000
export (float) var lightCooldown = 5
var direction: Vector2
onready var animationPlayer = $AnimationPlayer
var flipp = false
onready var droneArea = $DroneArea
var clamped: bool = false
signal dead

var jumpTimer := Timer.new()
export (float) var jumpDelay = 0.1

export var jumpHeight : float 
export var jumpTimetoPeak : float
export var jumpTimetoDescent : float 

onready var jumpVelocity : float = ((2.0 * jumpHeight) / jumpTimetoPeak) * -1.0
onready var jumpGravity : float  = ((-2.0 * jumpHeight) / (jumpTimetoPeak * jumpTimetoPeak)) * -1.0
onready var fallGravity : float  = ((-2.0 * jumpHeight) / (jumpTimetoDescent * jumpTimetoDescent)) * -1.0

var adjustJumpGrav = 200
var canJump = false
var inJump = false
export (float) var jumpMaxTime = 0.5
export (float) var jumpPressed = 1
var jumpStrength = 0
var adjustMovement
var droneAreaX

export var maxJumps := 1
var jumpAmount := maxJumps
var platformCounter
var onEntity = false

var particlePos
var particleRot

#animation states blending
var toIdle = false
var toJump = false

enum States{
	IDLE = 0,
	WALKING = 1,
	INAIR = 2
}
var state = States.IDLE
var nextState

func _ready():
	adjustMovement = 1
	platformCounter = 0
	droneAreaX = droneArea.position.x
	Checkpoint.last_position = global_position
	$AnimationPlayerDeath.play("RESET")
	

func get_Gravity() -> float:
	return jumpGravity if velocity.y < 0.0 else fallGravity


func _process(delta):
	pass
	
	
func _physics_process(delta):
	velocity.y += get_Gravity() * delta
	if is_on_floor():
		canJump = true
		if !$CoyoteTimer.is_stopped():
			$CoyoteTimer.stop()
	else:
		if canJump && $CoyoteTimer.is_stopped() && !Input.is_action_pressed("Jump"):
			$CoyoteTimer.start()
	if canJump && !inJump:
		if Input.is_action_pressed("Jump"):
			velocity.y = jumpVelocity
			inJump = true
			canJump = false
			$CoyoteTimer.stop()
	if inJump:
		jumpStrength -= delta*adjustJumpGrav
		if (jumpStrength <= jumpTimetoPeak*adjustJumpGrav) or Input.is_action_just_released("Jump"):
			velocity.y += jumpStrength
			jumpStrength = adjustJumpGrav
			inJump = false
			
	if state == States.WALKING:
		if Input.is_action_just_released("Left") && velocity.x < 0 || Input.is_action_just_released("Right") && velocity.x > 0:
			toIdle = true
	if Input.is_action_pressed("Left") && !Input.is_action_pressed("Right"):
		velocity.x -= acceleration
		if Input.is_action_just_pressed("Left") || Input.is_action_just_released("Right"):
			flip(true)
			droneArea.position.x = -droneAreaX
	elif Input.is_action_pressed("Right") && !Input.is_action_pressed("Left"):
		velocity.x += acceleration
		if Input.is_action_just_pressed("Right") || Input.is_action_just_released("Left"):
			flip(false)
			droneArea.position.x = droneAreaX
	else:
		velocity.x = lerp(velocity.x, 0, slow)
	velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	#velocity.y = clamp(velocity.y, -maxfallSpeed, maxfallSpeed)

	if clamped:
		if is_on_floor():
			velocity = Vector2(velocity.x * 0.5,0.0)
		else:
			velocity.y += adjustJumpGrav * delta
			velocity = Vector2(velocity.x * 0.5, velocity.y)
	
	changeState()
	
	velocity = move_and_slide(velocity, Vector2.UP,true,4,deg2rad(80.0))


func changeState():
	if !is_on_floor() && state != States.INAIR:
		if velocity.y > 0 && !inJump && $CoyoteTimer.is_stopped():
			startFall()
			print("startFall")
		elif velocity.y > 0 && inJump:
			startJump()
			print("startjump")
		elif velocity.y < 0:
			startJump()
			print("startjump")
	elif is_on_floor():
		if state == States.INAIR:
			setJumpSound()
			if abs(velocity.x) < 2 && !Input.is_action_pressed("Left") && !Input.is_action_pressed("Right"):
				idle()
				print("start idle")
			else:
				walking()
				print("start walk")
		elif abs(velocity.x) < 2 && !Input.is_action_pressed("Left") && !Input.is_action_pressed("Right"):
			if state != States.IDLE:
				idle()
				print("start idle")
		else:
			if state == States.WALKING && animationPlayer.current_animation == "idle" && (Input.is_action_pressed("Left") || Input.is_action_pressed("Right")):
				walking()
				print("start walk")
			elif state != States.WALKING:			
				walking()
				print("start walk")
	

func startJump():
	animationPlayer.play("jump")
	state = States.INAIR
	
	
func startFall():
	animationPlayer.play("fall")
	state = States.INAIR
	
	
func idle():
	if state == States.INAIR && animationPlayer.current_animation == "fall":
		animationPlayer.play("fall_end")
	else:
		animationPlayer.play("idle_start")
	velocity.x = 0
	state = States.IDLE
	


func walking():
	state = States.WALKING
	toIdle = false
	animationPlayer.play("walking")

	
func isPlayer():
	pass


func _on_DroneArea_body_entered(body):
	if body.has_method("stopChase"):
		body.stopChase()


func flip(value):
	$Walking.flip_h = value
	$Idle.flip_h = value
	$Jumping.flip_h = value
	$Falling.flip_h = value
	$Turn.flip_h = value
	$IdleStart.flip_h = value
	$IdleEnd.flip_h = value
	$FallEnd.flip_h = value
	$FallStart.flip_h = value
	if value:
		$Particles2D.scale = Vector2(-1,1)
		$Particles2D2.scale = Vector2(-1,1)
	else:
		$Particles2D.scale = Vector2(1,1)
		$Particles2D2.scale = Vector2(1,1)
	
func setParticleTransform():
	var jump = animationPlayer.get_animation("jump")
	var flip
	if $Jumping.flip_h:
		flip = -1
	else:
		flip = 1
	$Particles2D.position.x = jump.track_get_key_value(jump.find_track("Particles2D:position"), jump.track_find_key(jump.find_track("Particles2D:position"), animationPlayer.current_animation_position, false)).x*flip
	$Particles2D2.position.x = jump.track_get_key_value(jump.find_track("Particles2D2:position"), jump.track_find_key(jump.find_track("Particles2D2:position"), animationPlayer.current_animation_position, false)).x*flip
	$Particles2D.rotation_degrees = jump.track_get_key_value(jump.find_track("Particles2D:rotation_degrees"), jump.track_find_key(jump.find_track("Particles2D:rotation_degrees"), animationPlayer.current_animation_position, false))*flip
	$Particles2D2.rotation_degrees = jump.track_get_key_value(jump.find_track("Particles2D2:rotation_degrees"), jump.track_find_key(jump.find_track("Particles2D2:rotation_degrees"), animationPlayer.current_animation_position, false))*flip


	


func jump_timer_timeout():
	jumpAmount -= 1


func _on_AttackRangeFlying_body_entered(body):
	if body.has_method("playerInRange"):
		body.playerInRange(self)


func _on_CheckCollectibles_body_entered(body):
	if body.has_method("picked"):
		body.picked(self)
		
		
func death():
	$AnimationPlayerDeath.play("You_Died")
	clamped = false
	global_position = Checkpoint.last_position
	emit_signal("dead")
	

func deathFadeOut(boolV):
	if boolV:
		$AnimationPlayerDeath.play("Death Fade")
	else:
		$DeathSprite.visible = false
		

func setWalkSound1():
	if onEntity:
		#$AudioStreamPlayer.pitch_scale = rand_range(1.75, 2.25)
		$WalkOnEntity1.play()
	else:
		$WalkOnMetal1.play()


func setWalkSound2():
	if onEntity:
		$WalkOnEntity2.play()
	else:
		$WalkOnMetal2.play()


func setJumpSound():
	$CheckForPlatform.force_raycast_update()
	$CheckForPlatform2.force_raycast_update()
	if $CheckForPlatform.is_colliding() || $CheckForPlatform2.is_colliding():
		$JumpOnEntity.play()
	else:
		$JumpOnMetal.play()


func walkToIdle():
	if toIdle && !Input.is_action_pressed("Left") && !Input.is_action_pressed("Right"):
		print("walktoidle")
		animationPlayer.play("idle_start")
	toIdle = false
		
func walkToIdle2():
	if toIdle && !Input.is_action_pressed("Left") && !Input.is_action_pressed("Right"):
		print("walktoidle2")
		animationPlayer.play("idle")
	toIdle = false

		
func _on_AttackRangeFlying_body_exited(body):
	if body.has_method("playerInRange"):
		body.closeToAttack = false


func _on_CoyoteTimer_timeout():
	$CoyoteTimer.stop()
	if !is_on_floor():
		canJump = false
