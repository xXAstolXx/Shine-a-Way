extends Area2D

var active_checkpoint = false
export var energyValue = 100
#func _ready():
#	active_checkpoint = false

func _on_Checkpoint_body_entered(body):
	if body.name =="Player":
		Checkpoint.last_position = global_position
		body.get_node("../Drone").refillEnergy(energyValue)
		var sound_has_played = false
		if !sound_has_played:
			sound_has_played = true
			
		if !active_checkpoint:
			$AudioStreamPlayer2D.play()
			current_checkpoint()
	pass # Replace with function body.
func current_checkpoint():
	active_checkpoint = true
#	$Sprite.frame = 1
	$LampSprite/Light2D.visible = true
	$AnimationPlayer.play("activate once")
	pass

func _on_Checkpoint_body_exited(body):	
	pass # Replace with function body.
