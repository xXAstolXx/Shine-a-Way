extends Node2D

#export(bool) var dont_play = false
#export var (Array, String, "master", "reverb") bus : Array
#export var volume_click = 0.0
#export var volume_buzz = 0.0


func _ready():
#	$AudioStreamPlayer2D.stream_paused = dont_play
#	$AudioBuzzing.stream_paused = dont_play
#	$AudioPlayer.bus = bus
#	$AudioStreamPlayer2D.volume_db = volume_click
#	$AudioBuzzing.volume_db = volume_buzz
	pass

func _flickering():
	#$Light2D.energy = rand_range(0.0, 1.1)
	$AnimationPlayer.playback_speed = rand_range(1.0, 10.0)
	pass
func variation():
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.8, 1.2)
	pass
