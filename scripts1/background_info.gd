extends Control

@onready var faden : ColorRect = $MarginContainer/ColorRect2
@onready var fadeo : ColorRect = $MarginContainer/ColorRect3
@export var curve : Curve
@onready var fadeouttimer : Timer = $fadeouttimer
@onready var fps : Label = $Label
var fade_time : float = 3
@onready var backgroundnoise : AudioStreamPlayer = get_node("/root/Start_Screen/background")
func fadein():
	var fade_in = get_tree().create_tween()
	fade_in.tween_property(faden, "color", Color(0,0,0,0), fade_time).set_trans(Tween.TRANS_SINE)
	fade_in.finished.connect(time_inbetween)

func time_inbetween():
	var timer = get_tree().create_timer(15)
	timer.timeout.connect(fadeout)

func fadeout():
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(fadeo, "color", Color.BLACK, 2).set_trans(Tween.TRANS_SINE)
	fade_out.tween_property(backgroundnoise, "volume_db", -20, 2)
	fade_out.finished.connect(start_game)

func start_game():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _process(delta):
	fps.set_text("FPS %d" % Engine.get_frames_per_second())
	if Input.is_action_just_pressed("ui_cancel"):
		start_game()

func _ready():
	$windy.play()
func _on_timer_timeout():
	fadein()
