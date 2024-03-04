extends RayCast2D


var is_casting := false setget set_is_casting

func _ready():
	add_to_group("rays")
	set_physics_process(false)
	
	$Line2D.add_point(Vector2.ZERO,0)
	$Line2D.add_point(cast_to,1)


func _physics_process(delta: float) -> void:
		
	force_raycast_update()
	

func set_is_casting(cast: bool) -> void:
	is_casting = cast
	set_physics_process(is_casting)
	if is_casting:
		appear()
	else:
		disappear()

func appear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 0, 2, 0.2)
	$Tween.start()
	enabled = true
	
	
func disappear() -> void:
	$Tween.stop_all()
	$Tween.interpolate_property($Line2D, "width", 2, 0, 0.2)
	$Tween.start()
	enabled = false
