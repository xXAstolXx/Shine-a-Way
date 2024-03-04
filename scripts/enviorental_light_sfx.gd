extends Position2D

export var ambient_range = 2000
export var volume_mod =0
func _ready():
	$Audio.volume_db = volume_mod
	$Audio.max_distance = ambient_range
#
#	$Light2D.texture.width = ambient_range*2
#	$Light2D.texture.hight = ambient_range*2
