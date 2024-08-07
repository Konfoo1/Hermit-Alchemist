extends Area3D
class_name Vines

var player_in : bool = false
var player

func _process(_delta):
	if player_in:
		player.velocity.y = 2

func _on_body_exited(body):
	if body is Player:
		player_in = false

func _on_body_entered(body):
	if body is Player:
		player_in = true
		player = body
