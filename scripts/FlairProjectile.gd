extends RigidBody2D


onready var spawner = get_parent()
export (float) var speed = 800
var targetPosition
var lightFlair
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	position = position.move_toward(targetPosition, delta * speed)
	if position == targetPosition:
		spawner.spawnFlair(position)
		queue_free()
	

func _on_FlairProjectile_body_entered(body):
	print("body entered")
	if body.name != "Player":
		spawner.spawnFlair(position)
		queue_free()

