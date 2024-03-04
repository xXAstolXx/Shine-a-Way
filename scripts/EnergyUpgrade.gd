extends Area2D


export var energyValue = 10

func _ready():
	randomize()
	$AudioStreamPlayer.pitch_scale = rand_range(1.75, 2.25)
func delete():
	queue_free()
func pick_up_energy():
	pass


func _on_Energy_body_entered(body):
		$AnimationPlayer.play("picked up")
		body.get_node("../Drone").upgradeMaxEnergy(energyValue)
		print(energyValue, "picked")
		
