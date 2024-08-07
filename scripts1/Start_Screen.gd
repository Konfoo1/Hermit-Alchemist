extends Control
var fade_out_done : bool = false
@onready var fade : ColorRect = $MarginContainer/ColorRect
@onready var old_scene : MarginContainer = $MarginContainer
@onready var new_scene = preload("res://scenes/background_info.tscn")
@onready var fps : Label = $Label
# Called when the node enters the scene tree for the first tim
func _process(delta):
	fps.set_text("FPS %d" % Engine.get_frames_per_second())


func _on_button_pressed():
	$start.play()
	fade.visible = true
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(fade, "color",Color.BLACK,5).set_trans(Tween.TRANS_SINE)
	fade_out.finished.connect(start_background)
	

func start_background():
	get_child(0).queue_free()
	var n = new_scene.instantiate()
	add_child(n)
	


func _on_button_2_pressed():
	get_tree().quit()
