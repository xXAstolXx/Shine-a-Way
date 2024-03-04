extends Area2D


func delete():
	queue_free()
	print("tool in inventory: ", Global.toolCount)
	
func _ready():
	randomize()
	$AudioStreamPlayer.pitch_scale = rand_range(1.75, 2.25)

func _on_Energy_body_entered(body):
	if body.name == "Player":
#		$Label.text = strg(Global.toolCount)
		$AnimationPlayer.play("picked up")
		Global.toolCount += 1
		
func add_Collectible():
	pass
