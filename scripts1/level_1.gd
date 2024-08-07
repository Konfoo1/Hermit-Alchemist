extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$WorldEnvironment/DirectionalLight3D.rotation.x += .01 * delta
	pass



func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
