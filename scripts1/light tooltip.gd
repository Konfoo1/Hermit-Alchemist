extends Area3D
class_name light_tooltip



func _on_body_entered(body):
	if body is Player:
		body.set_tooltip("I might need a source of light")


func _on_body_exited(body):
	if body is Player:
		body.set_tooltip("")

