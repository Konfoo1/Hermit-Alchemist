extends Area3D
class_name Item

@export var item_number : int
@onready var main := get_node("/root/Main")
func get_item_number():
	return item_number
func _process(delta):
	var player = main.get("player_loaded")
	if player.get_goblin() == true:
		$GPUParticles3D.emitting = true
	else: $GPUParticles3D.emitting = false
