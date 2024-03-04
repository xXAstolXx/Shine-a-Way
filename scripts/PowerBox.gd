extends Area2D

onready var PowerBoxAni = $AnimationPlayer
#signal LevelEnd
onready var Canvas = get_node("../../CanvasModulate")

func _on_Area2D_body_entered(body):
	if body.has_method("isPlayer"):
		PowerBoxAni.play("Repaired")
		Canvas.visible = false
		yield(get_tree().create_timer(2), "timeout")
#		emit_signal("LevelEnd") 
