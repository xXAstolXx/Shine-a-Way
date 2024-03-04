extends RayCast2D




func _physics_process(delta):
	if is_colliding() && get_parent().onEntity == false:
		get_parent().onEntity = true
	elif !is_colliding() && get_parent().onEntity == true:
		get_parent().onEntity = false
		
