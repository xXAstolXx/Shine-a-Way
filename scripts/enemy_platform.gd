extends StaticBody2D



onready var animationPlayer = $AnimationPlayer

var delayStart = 0.0 #0.8
var delayEnd = 0.0 #0.5
var delayCol = 0.0 #0.4

#color
var fromC
var toC
var timeC
var changeColor = false
var segC
#transparency
var fromT
var toT
var timeT
var segT
var transparency = 1
var changeTransp = false
#transparency glow
var fromG
var toG
var timeG
var segG
var transparencyG = 1
var afterGlow = false
var fromD
var toD
var timeD
var segD
var distortion = 0.25
var distort = false

var fastEnd = false

func _ready():
	afterGlow = false
	setShader("afterGlow", false)
	changeTransp = false
	setShader("transparency", transparency)
	setShader("transparencyG", transparencyG)
	setShader("distortion", distortion)


func _process(delta):
	if changeTransp:
		setTransparency(delta)
	if afterGlow:
		setTransparencyG(delta)
	if distort:
		setDistortion(delta)
	if changeColor:
		setColor(delta)
		
		
func stunStart():
	print("#############startAni")
	if animationPlayer.current_animation == "idle" or animationPlayer.current_animation == "Stun" or animationPlayer.current_animation == "Stun_End":
		print("hit")
		changeTransp = true
		fromT = transparency
		toT = 0
		timeT = 1
		if afterGlow:
			fromG = transparencyG
			toG = toT
			timeG = timeT
		distort = true
		fromD = distortion
		toD = 0
		timeD = 0.5
		yield(get_tree().create_timer(delayStart),"timeout")
		animationPlayer.play("Stun_Start")
		
		
func stunEnd():
	if animationPlayer.current_animation == "Stun":
		yield(get_tree().create_timer(delayStart),"timeout")
		animationPlayer.play("Stun_End")
	elif animationPlayer.current_animation == "idle" or animationPlayer.current_animation == "Stun_Start":
		fastEnd = true


func startfollowUp():
	if fastEnd:
		yield(get_tree().create_timer(delayStart),"timeout")
		animationPlayer.play("Stun_End")
	else:
		animationPlayer.play("Stun")
	fastEnd = false

		
func ending():
	fromT = transparency
	toT = 1
	timeT = 0.5
	changeTransp = true
	
	transparencyG = transparency
	fromG = transparencyG
	toG = 1
	timeG = 1
	afterGlow = true
	setShader("afterGlow", true)
	
	fromD = distortion
	toD = 0.25
	timeD = 0.5
	distort = true
			
			
func setColor(delta):
	segC = (abs(fromC-toC)*delta)/timeC
	if fromC <= toC:
		modulate.a += segC
		if modulate.a >= toC:
			changeColor = false
	if fromC > toC:
		modulate.a -= segC
		if modulate.a <= toC:
			changeColor = false
			
func setTransparency(delta):
	segT = (abs(fromT-toT)*delta)/timeT
	if fromT <= toT:
		transparency += segT
		if transparency >= toT:
			transparency = toT
			changeTransp = false
	elif fromT > toT:
		transparency -= segT
		if transparency <= toT:
			changeTransp = false
			transparency = toT
	setShader("transparency",transparency)
			
func setTransparencyG(delta):
	segG = (abs(fromG-toG)*delta)/timeG
	if fromG <= toG:
		transparencyG += segG
		if transparencyG >= toG:
			afterGlow = false
			setShader("afterGlow", false)
			transparencyG = toG
	elif fromG > toG:
		transparencyG -= segG
		if transparencyG <= toG:
			afterGlow = false
			setShader("afterGlow", false)
			transparencyG = toG
	setShader("transparencyG", transparencyG)
	

func setDistortion(delta):
	segD = (abs(fromD-toD)*delta)/timeD
	if fromD <= toD:
		distortion += segD
		if distortion >= toD:
			distort = false
			distortion = toD
	elif fromD > toD:
		distortion -= segD
		if distortion <= toD:
			distort = false
			distortion = toD
	setShader("distortion", distortion)
	

func setShader(name, transparency):
	$AnimatedSpriteIdle.material.set_shader_param(name, transparency)
	$AnimatedSpriteStun.material.set_shader_param(name, transparency)
	$AnimatedSpriteStunEnd.material.set_shader_param(name, transparency)
	$AnimatedSpriteStunStart.material.set_shader_param(name, transparency)


func collisionDelay():
	yield(get_tree().create_timer(delayCol),"timeout")
	if $AnimationPlayer.current_animation == "idle":
		$CollisionPlayer.disabled = true



