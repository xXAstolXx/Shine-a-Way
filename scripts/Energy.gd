extends Area2D

export var energyValue = 30

func _ready():
	randomize()
	$AudioStreamPlayer.pitch_scale = rand_range(0.75, 1.25)

func delete():
	queue_free()
	
#func _ready():
#	randomize()
#	$AudioStreamPlayer.pitch_scale = rand_range(0.75, 1.25)

func _on_Energy_body_entered(body):
	if body.name == "Player":
		$AnimationPlayer.play("picked up")
		Global.energyStored += energyValue
		body.get_node("../Drone").refillEnergy(energyValue)
		#print(energyValue, "picked")
