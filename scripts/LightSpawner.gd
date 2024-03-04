extends Node2D


export (PackedScene) var flairProjectileTemplate
export (PackedScene) var lightFlairTemplate
export (PackedScene) var laserTemplate


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func spawnProjectile(targetPos):#
	var flairProjectile = flairProjectileTemplate.instance()
	flairProjectile.targetPosition = targetPos - global_position
	add_child(flairProjectile)
	
func spawnFlair(spawnPos):
	var lightFlair = lightFlairTemplate.instance()
	lightFlair.position = spawnPos
	add_child(lightFlair)
	
	
func spawnLaser(targetPos):
	var laser = laserTemplate.instance()
	laser.targetPos = targetPos - global_position
	add_child(laser)
