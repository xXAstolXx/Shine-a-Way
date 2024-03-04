extends Light2D
var delayPlatformCollision = 2



func _on_DetectionArea_area_entered(area):

	if area.get_parent().has_method("stunStart"):
		area.get_parent().stunStart()
		#get player reference 
	if area.get_parent().has_method("activate"):
		area.get_parent().activate()


func _on_DetectionArea_area_exited(area):
	if area.get_parent().has_method("deactivate"):
		area.get_parent().deactivate()
	if area.get_parent().has_method("stunEnd"):
		area.get_parent().stunEnd()


func _on_DetectionArea_body_entered(body):
	if body.has_method("inLightRange"):
		body.inLightRange(body.global_position - global_position, get_parent().get_parent())
	if body.has_method("hit"):
		body.hit()


func _on_DetectionArea_body_exited(body):
	if body.has_method("stopHit"):
		print("flare gone")
		body.stopHit()
