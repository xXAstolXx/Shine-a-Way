extends StaticBody2D



onready var animationPlayer = $AnimationPlayer
onready var positionalAudio = $AudioStreamPlayer2D
onready var stunnedAudio = $Audio_Hit_Player
var back = false

func _ready():
	pass


func _process(delta):
	pass


func stunStart():
	print("#############startAni")
	if animationPlayer.current_animation == "idle":
		print("hit")
		setEndCheck(false)
		animationPlayer.play("Stun_Start")
		

func stunEnd():
	if animationPlayer.current_animation == "Stun_Get_Grey" || animationPlayer.current_animation == "":
		animationPlayer.stop(false)
		animationPlayer.play_backwards("Stun_Get_Grey")
		setEndCheck(true)


func setEndCheck(end):
	back = end
	
	
func playEnd():
	if back:
		animationPlayer.play("Stun_End")
