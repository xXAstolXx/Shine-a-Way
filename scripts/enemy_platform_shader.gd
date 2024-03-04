extends StaticBody2D



onready var animationPlayer = $AnimationPlayer
onready var positionalAudio = $AudioStreamPlayer2D
onready var stunnedAudio = $Audio_Hit_Player
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
var changeTransp = false

var fastEnd = false

func _ready():
	modulate.a = 0


func _process(delta):
	if changeTransp:
		setTransparency(delta)
	if changeColor:
		setColor(delta)
		
		
func stunStart():
	print("#############startAni")
	if animationPlayer.current_animation == "idle":
		print("hit")
		changeTransp = true
		fromT = modulate.a
		toT = 1
		timeT = 1
		yield(get_tree().create_timer(0.3),"timeout")
		animationPlayer.play("Stun_Start")
		
		
func stunEnd():
	if animationPlayer.current_animation == "Stun":
		animationPlayer.play("Stun_End")
	elif animationPlayer.current_animation == "idle" or animationPlayer.current_animation == "Stun_Start":
		fastEnd = true


func startfollowUp():
	if fastEnd:
		animationPlayer.play("Stun_End")
	else:
		animationPlayer.play("Stun")
	fastEnd = false

		
func ending():
	fromT = modulate.a
	toT = 0
	timeT = 2
	changeTransp = true
			
			
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
		modulate.a += segT
		if modulate.a >= toT:
			changeTransp = false
	if fromT > toT:
		modulate.a -= segT
		if modulate.a <= toT:
			changeTransp = false
