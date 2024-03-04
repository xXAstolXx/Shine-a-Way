extends StaticBody2D

onready var col = $CollisionShape2D




func _ready():
	$Light2DLeft1.enabled = true
	$Light2DRight1.enabled = true
	$Light2DLeft2.enabled = false
	$Light2DRight2.enabled = false
	col.call_deferred("set", "disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func activate():
	$Light2DLeft1.enabled = false
	$Light2DRight1.enabled = false
	$Light2DLeft2.enabled = true
	$Light2DRight2.enabled = true
	col.call_deferred("set", "disabled", false)
	
func deactivate():
	yield(get_tree().create_timer(0.5), "timeout")
	col.call_deferred("set", "disabled", true)
	$Light2DLeft1.enabled = true
	$Light2DRight1.enabled = true
	$Light2DLeft2.enabled = false
	$Light2DRight2.enabled = false
