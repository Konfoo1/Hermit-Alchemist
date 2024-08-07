extends Node3D
class_name sleep_dart
var speed := 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.z += speed *delta


func _on_area_3d_body_entered(body):
	if not body is Player:
		self.queue_free()
	if body is Mob:
		body.sleepdart()
