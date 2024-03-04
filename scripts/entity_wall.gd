extends StaticBody2D



onready var animationPlayer = $AnimationPlayer

var timerStarted = false
var delayRecover = 2
export (float) var brightness = 0
export (bool) var addBrightness = false

func _ready():
	$Timer.set_wait_time(delayRecover)
	$Timer.one_shot = true
	$Timer.autostart = false
	setShader("addBrightness", brightness)

func _process(delta):
	if addBrightness:
		setShader("addBrightness", brightness)


func hit():
	$Timer.stop()
	if $AnimatedSpriteIdle.visible == true:
		animationPlayer.play("hide")
	
	
func stopHit():
	if $AnimatedSpriteIdle.visible == false:
		$Timer.start()
	

func _on_Timer_timeout():
	print("timeout")
	animationPlayer.play_backwards("hide")
	animationPlayer.queue("idle")
	timerStarted = false
	
	
func setShader(name, brightness):
	$AnimatedSpriteIdle.material.set_shader_param(name, brightness)
	$AnimatedSpriteScared.material.set_shader_param(name, brightness)
