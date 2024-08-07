extends CharacterBody3D
class_name Player

@onready var lightdetect := $SubViewport/LightDetection
@onready var texture_rect := $light_bar/TextureRect
@onready var color_rect := $ColorRect
@onready var subviewport := $SubViewport
@onready var light_level := $light_bar
@onready var camera := $Camera3D
@onready var sight_line := $Camera3D/RayCast3D
@onready var side_bar := $sidebar
@onready var side_bar_container := $sidebar/TextureRect
@onready var main := get_node("/root/Main")
@onready var label : Label = $Label
@onready var potion_side_bar_container := $potion_side_bar
@onready var potion_side_bar := $potion_side_bar/TextureRect2/GridContainer
@onready var potion1 := $potion_side_bar/TextureRect2/GridContainer/Potion1
@onready var potion2 := $potion_side_bar/TextureRect2/GridContainer/Potion2
@onready var potion3 := $potion_side_bar/TextureRect2/GridContainer/Potion3
@onready var sleepdartprojectile := preload("res://scenes/sleepdart.tscn")
@onready var countdowntimer : Timer= $countdown/countdownTimer

var ingredients : Dictionary = {
	100: ["Soiled Dirt","Tainted Dirt","res://assets/Ingredients/soileddirt.png",1],
	101: ["Crows Feather","Dark and Shiny","res://assets/Ingredients/crows feathers.png",1],
	102: ["Gold Nugget","We're RICH!","res://assets/Ingredients/goldnugget.png",1],
	103: ["Diamond","ooOOoo Shiny!","res://assets/Ingredients/DIAMOND.png",1],
	104: ["Untrimed Bush","Needs a trim","res://assets/Ingredients/untrimmedbush.png",1],
	105: ["Silver coin","Small Dulled Coin","res://assets/Ingredients/SILVER COIN.png",1],
	106: ["Copper Coin","Small Brown Coin","res://assets/Ingredients/COPPER COIN.png",1],
	107: ["Mushrooms","... do NOT eat...","res://assets/Ingredients/MUSHROOMS.png",1],
	108: ["Candle Flame","How did y-","res://assets/Ingredients/CANDLE FLAME.png",1],
	109: ["Golden Feather","Gold and even more shiny","res://assets/Ingredients/GOLDEN FEATHERS.png",1],
	110: ["Toad","Covered in Warts","res://assets/Ingredients/FROG.png",1],
	111: ["Shadow Crystal","Crystal With Swirling Clouds of Smoke","res://assets/Ingredients/SHADOWCRYSTAL.png",1]
	}

var dash := false
var speedpotion := false
var doublejump := false
var light := false
var darkness := false
var invisibility := false
var sleepdart := false
var goblineye := false
var wildgrowth := false
var timefreeze := false
var timefreeze_status := false

var dashing = false
var can_dash = true
var potions : Dictionary = {
	0: ["Dash","Allows for a short dash",[101,109,110],"res://assets/potions/yellow potion.png",dash],
	1: ["Speed","Increase your tiny legs speed",[101,102,110],"res://assets/potions/orange potion.png",speedpotion],
	2: ["Double Jump","Conjuours solid air underneath your feet to reach high areas",[101,105,110],"res://assets/potions/red potion.png",doublejump],
	3: ["Light","Emit a small amount of light, at the cost of what little stealth you already had",[106,108,110],"res://assets/potions/white potion.png",light],
	4: ["Darkness","Throw at lamps to absorb all light",[100,101,107],"res://assets/potions/potion.png",darkness],
	5: ["Invisibility","As you can see ... they cannot",[100,101,109],"res://assets/potions/Invisibility potion.png",invisibility],
	6: ["Sleep Dart","Knocks out recipiant for 30 seconds",[104,107,108],"res://assets/potions/purple potion.png",sleepdart],
	7: ["Goblin Eye","Your eyes become an uncomfortable green color which alows you to see ingredients better",[102,105,106],"res://assets/potions/green potion.png",goblineye],
	8: ["Wild Growth©","Causes plants or vines to rapidly grow",[100,104,107],"res://assets/potions/brown potion.png",wildgrowth],
	9: ["Time Freeze","Freeze time for a short period",[100,108,109],"res://assets/potions/blue potion.png",timefreeze],
	10: ["Philosiphers Stone","You Did it... yay.",[111,109,103],"res://assets/potions/stone.png",],
	20: ["Nothing","Nothing",[20,20,20],"res://assets/ui/PANELS.PNG",]
	}

var light_visibility : float

var picked_up_items : Dictionary = {}


var pause = false
var accumulated_input := Vector3.ZERO
var speed = 2
 # Movement speed
var acceleration = 5.0  # How quickly the character accelerates
var deceleration = 10.0  # How quickly the character decelerates
const MAX_SPEED = 2
const JUMP_VELOCITY = 7
var mouseSensitivity = 500
var mouse_relative_x = 0
var mouse_relative_y = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var wall_jump_momentum := Vector3.ZERO
const WALL_JUMP_POWER_X := 1000
const WALL_JUMP_POWER_Y := 500
var can_wall_jump := true
var wall_jumping := false
var wall_jump_momentum_duration := 0.5
var wall_jump_momentum_decay := 0.1

var max_camera_roll := 5
var can_move := true
var moving := false
var double_jump_times :int= 0
var jumping := false
var potion_inventory := []

var caught:= false

var rpressed := false
var qpressed := false
var night_number := 0

func _ready():
	fade_in()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	subviewport.debug_draw = 2
	night_counter()
	night_number = main.get_night_number()

func hidemouse():
	if Input.is_action_just_pressed("fix_cursor"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	movement(delta)
	wall_jump(delta)
	move_and_slide()
	camera_bump(delta)
	ground_pound(delta)
	crouch()
	lightdetection()
	click_monitor()
	side_bar_controller()
	potion_side_bar_controller()
	potion_effects_controller()
	dash_handle()
	countdownhandle()
	qandrtooltip()
	hidemouse()

func qandrtooltip():
	if night_number == 1:
		$qtooltip.visible = true
		$rtooltip.visible = true
		if qpressed == false:
			if Input.is_action_pressed("potion_side_bar"):
				qpressed = true
				$qtooltip.visible = false
		else: $qtooltip.visible = false
		if rpressed == false:
			if Input.is_action_pressed("side_bar"):
				rpressed = true
				$rtooltip.visible = false
		else: $rtooltip.visible = false
	elif night_number != 1:
		$rtooltip.visible = false
		$qtooltip.visible = false

func countdownhandle():
	if countdowntimer.time_left <= 30 and $countdownaudio.playing == false:
		$countdownaudio.play()
	$countdown.set_text("Time Left: " + str(int(countdowntimer.time_left)))

func night_counter():
	$Night_counter.set_text("Night: "+ str(main.get_night_number()))

func movement(delta):
	if not is_on_floor() and dashing == false:
		velocity.y -= gravity * delta
	else: velocity.y = 0
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y))
	if direction and can_move:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		moving = true
	else:
		if is_on_floor():
			velocity.x = 0
			velocity.z = 0
			moving = false
	if dashing:
		velocity = direction * 100
		dashing = false
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		$jumping.play()
		await get_tree().create_timer(.5).timeout
		jumping = true
	elif Input.is_action_just_pressed("ui_accept") and potions.get(2)[4] and double_jump_times < 1:
		velocity.y = JUMP_VELOCITY
		double_jump_times += 1
		$jumping.play()
	if is_on_floor():
		double_jump_times = 0
	if is_on_floor() and jumping:
		jumping = false
		$landing.play()


func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensitivity
		$Camera3D.rotation.x -= event.relative.y / mouseSensitivity
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90),deg_to_rad(90))
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 50)



func check_wall_jump():
	if is_on_wall_only() and can_wall_jump:
		return true
	else:
		return false

func wall_jump(_delta):
	if check_wall_jump() and Input.is_action_just_pressed("jump"):
		var input_dir = Input.get_vector("left", "right", "forward", "back")
		#wall_jump_momentum += jump_dir * WALL_JUMP_POWER_X * delta
		can_wall_jump = false
		wall_jumping = true
		$Wall_jumping_timer.start() #turn off movemnt timer
		$Wall_Jump_Cooldown.start()
		#velocity = wall_jump_momentum
		#velocity.y = JUMP_VELOCITY

func camera_roll(delta):
	var camera = $Camera3D
	var target_roll = Vector3(0, 0, 0)
	if Input.is_action_pressed("left"):
		target_roll.z = max_camera_roll
	elif Input.is_action_pressed("right"):
		target_roll.z = -max_camera_roll
	else: 
		target_roll.z = 0
	camera.rotation_degrees.z = lerp(camera.rotation_degrees.z, target_roll.z, delta * 5)

func camera_bump(_delta):
	if moving and is_on_floor():
		$Camera3D/AnimationPlayer.queue("Camera_bumb")
	else:
		$Camera3D/AnimationPlayer.stop()

func ground_pound(_delta):
	if Input.is_action_just_pressed("slam") and not is_on_floor():
		gravity = 700
	else:
		gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func crouch():
	if Input.is_action_pressed("crouch"):
		scale.y = .6
		speed = 2
	else:
		scale.y = 1
		if potions.get(1)[4]:
			speed = 5
		else:
			speed = 3.5

func _on_wall_jump_cooldown_timeout():
	can_wall_jump = true

func _on_wall_jumping_timer_timeout():
	wall_jumping = false

func lightdetection():
	lightdetect.global_position = global_position
	var texture = subviewport.get_texture()
	texture_rect.set_texture(texture)
	texture_rect.size = Vector2(10,10)
	var color = get_average_color(texture)
	color_rect.color = color
	light_level.value = color.get_luminance()
	light_visibility = int(clampf(color.get_luminance(),0,0.5) * 2 * 100)
	if invisibility:
		light_level.value = 0
		light_visibility = 0
	else:
		light_level.value = light_visibility

func get_average_color(texture : ViewportTexture):
	var image = texture.get_image()
	image.resize(1,1,Image.INTERPOLATE_LANCZOS)
	return image.get_pixel(0,0)

func get_light_visibility():
	return light_visibility

func click_monitor():
	if sight_line.is_colliding():
		if sight_line.get_collider() is Exfil:
			label.set_text("Click to head back to camp")
			if Input.is_action_just_pressed("click"):
				fade_out()
		if sight_line.get_collider() is wildgrowthplant:
			label.set_text("I could use a potion on this")
			if Input.is_action_just_pressed("click") and wildgrowth:
				sight_line.get_collider().get_parent().grow()
		if sight_line.get_collider() is Item:
			var item_number = sight_line.get_collider().get_item_number()
			var item_array = ingredients.get(item_number)
			label.set_text("Click to pick up " + item_array[0])
			if Input.is_action_just_pressed("click"):
				pick_up_item(item_number, item_array)
				sight_line.get_collider().queue_free()
				$Camera3D/pickupitem.play()
	else: label.set_text("")

func fade_in():
	var c :ColorRect= ColorRect.new()
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.color = Color("BLACK",1)
	add_child(c)
	var tween = get_tree().create_tween()
	tween.tween_property(c, "color",Color("BLACK", 0),1).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(1).timeout
	c.queue_free()

func fade_out():
	var c :ColorRect= ColorRect.new()
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.color = Color("BLACK",0)
	add_child(c)
	var tween = get_tree().create_tween()
	$digging.play()
	tween.tween_property(c, "color",Color.BLACK,1).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(next_level)

func next_level():
	main.player_exfil(picked_up_items)

func set_tooltip(text : String):
	$Label2.set_text(text)

func pick_up_item(item_number, item_array : Array):
	var item_position := Vector2.ZERO
	main.ingredients_collected_add_one()
	if picked_up_items.has(item_number):
		pass
	else:
		picked_up_items.merge({item_number: item_array})
		picked_up_items.get(item_number)[3] += randi_range(1,3)
	var item_image := load(item_array[2])
	var item_texture : TextureRect = TextureRect.new()
	item_texture.set_texture(item_image)
	side_bar_container.add_child(item_texture)
	item_texture.set_scale(Vector2(2,2))
	if picked_up_items.size() % 2 == 0:
		item_position.x = 128
	else: item_position.x = 0
	if picked_up_items.size() == 1 or picked_up_items.size() == 2:
		item_position.y = 0
	elif picked_up_items.size() == 3 or picked_up_items.size() == 4:
		item_position.y = 128
	elif picked_up_items.size() == 5 or picked_up_items.size() == 6:
		item_position.y = 256
	elif picked_up_items.size() == 7 or picked_up_items.size() == 8:
		item_position.y = 384
	elif picked_up_items.size() == 9 or picked_up_items.size() == 10:
		item_position.y = 512
	elif picked_up_items.size() == 11 or picked_up_items.size() == 12:
		item_position.y = 640
	item_texture.position = item_position

func side_bar_controller():
	if Input.is_action_just_pressed("side_bar"):
		if side_bar.position != Vector2(0,0):
			var tween = get_tree().create_tween()
			tween.tween_property(side_bar, "position", Vector2(0,0), 1.0).set_trans(Tween.TRANS_SINE)
	else:
		if side_bar.position == Vector2(0,0) and not Input.is_action_pressed("side_bar"):
			var tween = get_tree().create_tween()
			tween.tween_property(side_bar, "position", Vector2(256,0), 1.0).set_trans(Tween.TRANS_SINE)

func fade_outcaught():
	var c :ColorRect= ColorRect.new()
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.color = Color("BLACK",0)
	add_child(c)
	var tween = get_tree().create_tween()
	if $caught.playing == false:
		$caught.play()
	tween.tween_property(c, "color",Color.BLACK,3.8).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(next_level)

func player_caught():
	if caught == false:
		picked_up_items.clear()
		fade_outcaught()
		hide_ui()
		caught = true
	

func set_potion_inventory(potions : Array):
	potion_inventory = potions

func hide_ui():
	$light_bar.visible = false
	$sidebar.visible = false

func unhide_ui():
	$light_bar.visible = true
	$sidebar.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func potion_side_bar_controller():
	if Input.is_action_just_pressed("potion_side_bar"):
		if potion_side_bar_container.position != Vector2(256,0):
			var tween = get_tree().create_tween()
			tween.tween_property(potion_side_bar_container, "position", Vector2(256,0), 1.0).set_trans(Tween.TRANS_SINE)
	else:
		if potion_side_bar_container.position == Vector2(256,0) and not Input.is_action_pressed("potion_side_bar"):
			var tween = get_tree().create_tween()
			tween.tween_property(potion_side_bar_container, "position", Vector2(0,0), 1.0).set_trans(Tween.TRANS_SINE)
	
	if potion_inventory.size() >= 1:
		potion1.set_texture(load(potions.get(potion_inventory[0])[3]))
		if potion_inventory.size() >= 2:
			potion2.set_texture(load(potions.get(potion_inventory[1])[3]))
		if potion_inventory.size() == 3:
			potion3.set_texture(load(potions.get(potion_inventory[2])[3]))
	else:
		potion1.set_texture(load("res://assets/ui/PANELS.PNG"))
		potion2.set_texture(load("res://assets/ui/PANELS.PNG"))
		potion3.set_texture(load("res://assets/ui/PANELS.PNG"))

func potion_effects_controller():
	if potions.get(5)[4]:
		invisibility = true
		light_visibility = 0
	if potions.get(3)[4]:
		$OmniLight3D.visible = true
	else:
		$OmniLight3D.visible = false
	if potions.get(4)[4]:
		$darkness.visible = true
	else:
		$darkness.visible = false
	if Input.is_action_just_pressed("1") and potion_inventory.size() >= 1 and potion_inventory[0] != 20:
		potions.get(potion_inventory[0])[4] = true
		potion_inventory[0] = 20
		main.potions_used_add_one()
	if Input.is_action_just_pressed("2") and potion_inventory.size() >= 2 and potion_inventory[1] != 20:
		potions.get(potion_inventory[1])[4] = true
		potion_inventory[1] = 20
		main.potions_used_add_one()
	if Input.is_action_just_pressed("3") and potion_inventory.size() == 3 and potion_inventory[2] != 20:
		potions.get(potion_inventory[2])[4] = true
		potion_inventory[2] = 20
		main.potions_used_add_one()
	if potions.get(7)[4] == true:
		$goblinmode.visible = true
	else: $goblinmode.visible = false
	if potions.get(6)[4]:
		sleepdartshot()
	if potions.get(9)[4]:
		timefreezestart()
	if potions.get(8)[4]:
		wildgrowth = true

func dash_handle():
	if potions.get(0)[4]:
		if dashing == false:
			if Input.is_action_just_pressed("dash"):
				dashing = true
				$dash_timer.start()
		if is_on_floor():
			can_dash = true

func timefreezestart():
	potions.get(9)[4] = false
	$timefreeze.start()
	timefreeze_status = true
	countdowntimer.set_paused(true)

func sleepdartshot():
	potions.get(6)[4] = false
	if sight_line.is_colliding():
		if sight_line.get_collider() is Mob:
			sight_line.get_collider().sleepdart()

func get_time_freeze():
	return timefreeze_status

func get_goblin():
	return potions.get(7)[4]

func _on_timefreeze_timeout():
	print_debug("now")
	timefreeze_status = false
	countdowntimer.set_paused(false)


func _on_dash_timer_timeout():
	dashing = false
	can_dash = false


func _on_countdown_timer_timeout():
	player_caught()
