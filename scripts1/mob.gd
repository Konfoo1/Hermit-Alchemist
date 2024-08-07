extends CharacterBody3D
class_name  Mob

var player
var incone := false
var sightline := false
const SPEED = 2.5
var alert := 0.0
var last_known_location := Vector3.ZERO
var asleep := false
@onready var alarmed := $alarmed
@onready var sightlinetoplayer := $RayCast3D
@onready var pathfollow : PathFollow3D =  get_parent()
@onready var head := $"character-digger/root/torso/head"
@onready var animation :AnimationPlayer= $AnimationPlayer
@onready var main := get_node("/root/Main")
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var player_froze_time := false

func _process(delta):
	if player == null:
		player = get_node("/root/Main/Player/Player")
	player_froze_time = player.get_time_freeze()
	monitor_player()
	visibiltycalc()
	movement(delta)

func movement(delta):
	if player_froze_time == false and asleep == false:
		if alert <= 0.1:
			pathfollow.progress += SPEED * delta
			head.rotation = Vector3(0,0,0)
			animation.play("walk")
		else: 
			animation.play("holding-right")

func monitor_player():
	sightlinetoplayer.target_position = to_local(player.global_position)
	sightlinetoplayer.target_position.y -= .3
	sightlinetoplayer.debug_shape_custom_color = Color.RED
	if sightlinetoplayer.is_colliding():
		if sightlinetoplayer.get_collider() == player:
			sightline = true
		else: sightline = false
	else: sightline = false

func visibiltycalc():
	var player_stealth = player.get_light_visibility()
	if player.get_time_freeze() == false:
		if incone and sightline:
			head.look_at((player.global_position + Vector3(0,-1,0)))
			head.rotate_y(deg_to_rad(180))
			if alert < 1 and player_stealth > 10:
				alert += (1 * player_stealth) * .0005
		elif alert != 1:
			alert -= 0.005
		alert = clampf(alert, 0 , 1)
		if Input.is_action_just_pressed("ui_end"):
			alert = 0
		if alert > 0:
			alarmed.visible = true
			alarmed.modulate.a = alert
		else: 
			alarmed.visible = false
		if alert == 1:
			main.player_caught()

func _on_sight_body_entered(body):
	if body is Player:
		incone = true

func sleepdart():
	asleep = true
	rotation.x = deg_to_rad(90)
	$sleeptimer.start()
	animation.play("holding-right")

func _on_sight_body_exited(body):
	if body is Player:
		incone = false


func _on_sleeptimer_timeout():
	asleep = false
	rotation.x = deg_to_rad(0)
