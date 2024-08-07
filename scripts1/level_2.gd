extends Control
@onready var main := get_node("/root/Main")
#Ingredient Array Foramt = ID : [Ingredient, Description, Image, amount]
var inventory_stash := {}
var crafting_slots := []
var potions := []
@onready var tooltip :Label = $tooltip
var potionslist : Dictionary = {
	0: ["Dash","Allows for a short dash using CTRL",[101,109,110],"res://assets/potions/yellow potion.png"],
	1: ["Speed","Increase your tiny legs speed",[101,102,110],"res://assets/potions/orange potion.png"],
	2: ["Double Jump","Conjuours solid air underneath your feet to reach high areas",[101,105,110],"res://assets/potions/red potion.png"],
	3: ["Light","Emit a small amount of light, at the cost of what little stealth you already had",[106,108,110],"res://assets/potions/white potion.png"],
	4: ["Darkness","Shroud yourself in darkness, become harder to see",[100,101,107],"res://assets/potions/potion.png"],
	5: ["Invisibility","As you can see ... they cannot",[100,101,109],"res://assets/potions/Invisibility potion.png"],
	6: ["Sleep Dart","Knocks out recipiant for 30 seconds, very short range",[104,107,108],"res://assets/potions/purple potion.png"],
	7: ["Goblin Eye","Your eyes become an uncomfortable green color which alows you to see ingredients better",[102,105,106],"res://assets/potions/green potion.png"],
	8: ["Wild Growth©","Causes plants or vines to rapidly grow, click glowy plants",[100,104,107],"res://assets/potions/brown potion.png"],
	9: ["Time Freeze","Freeze time for a short period",[100,108,109],"res://assets/potions/blue potion.png"],
	10: ["Philosiphers Stone","You Did it... yay.",[111,109,103],"res://assets/potions/stone.png"]
	}

var ingredientslist : Dictionary = {
	100: ["Soiled Dirt","Tainted Dirt","res://assets/Ingredients/soileddirt.png",0],
	101: ["Crows Feather","Dark and Shiny","res://assets/Ingredients/crows feathers.png",0],
	102: ["Gold Nugget","We're RICH!","res://assets/Ingredients/goldnugget.png",0],
	103: ["Diamond","ooOOoo Shiny!","res://assets/Ingredients/DIAMOND.png",1],
	104: ["Untrimed Bush","Needs a trim","res://assets/Ingredients/untrimmedbush.png",0],
	105: ["Silver coin","Small Dulled Coin","res://assets/Ingredients/SILVER COIN.png",0],
	106: ["Copper Coin","Small Brown Coin","res://assets/Ingredients/COPPER COIN.png",0],
	107: ["Mushrooms","... do NOT eat...","res://assets/Ingredients/MUSHROOMS.png",0],
	108: ["Candle Flame","How did y-","res://assets/Ingredients/CANDLE FLAME.png",0],
	109: ["Golden Feather","Gold and even more shiny","res://assets/Ingredients/GOLDEN FEATHERS.png",1],
	110: ["Toad","Covered in Warts","res://assets/Ingredients/FROG.png",0],
	111: ["Shadow Crystal","Crystal With Swirling Clouds of Smoke","res://assets/Ingredients/SHADOWCRYSTAL.png",1]
	}

@onready var crafting_slot_1 :TextureRect= $crafting/GridContainer/Crafting1
@onready var crafting_slot_2 :TextureRect= $crafting/GridContainer/Crafting2
@onready var crafting_slot_3 :TextureRect= $crafting/GridContainer/Crafting3
@onready var potion_slot_1 : MenuButton= $Potions/GridContainer/Potion1
@onready var potion_slot_2 : MenuButton= $Potions/GridContainer/Potion2
@onready var potion_slot_3 : MenuButton= $Potions/GridContainer/Potion3
# Called when the node enters the scene tree for the first time.
func _ready():
	fade_in()
	inventory_stash = main.get_inventory_stash()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	for i in inventory_stash.keys():
		if inventory_stash.get(i)[3] == 1:
			inventory_stash.get(i)[3] += randi_range(1,2)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in inventory_stash.keys():
		if i == 100:
			$"Label/GridContainer/100/amount".set_text(str(inventory_stash.get(100)[3]))
		elif i == 101:
			$"Label/GridContainer/101/amount".set_text(str(inventory_stash.get(101)[3]))
		elif i == 102:
			$"Label/GridContainer/102/amount".set_text(str(inventory_stash.get(102)[3]))
		elif i == 103:
			$"Label/GridContainer/103/amount".set_text(str(inventory_stash.get(103)[3]))
		elif i == 104:
			$"Label/GridContainer/104/amount".set_text(str(inventory_stash.get(104)[3]))
		elif i == 105:
			$"Label/GridContainer/105/amount".set_text(str(inventory_stash.get(105)[3]))
		elif i == 106:
			$"Label/GridContainer/106/amount".set_text(str(inventory_stash.get(106)[3]))
		elif i == 107:
			$"Label/GridContainer/107/amount".set_text(str(inventory_stash.get(107)[3]))
		elif i == 108:
			$"Label/GridContainer/108/amount".set_text(str(inventory_stash.get(108)[3]))
		elif i == 109:
			$"Label/GridContainer/109/amount".set_text(str(inventory_stash.get(109)[3]))
		elif i == 110:
			$"Label/GridContainer/110/amount".set_text(str(inventory_stash.get(110)[3]))
		elif i == 111:
			$"Label/GridContainer/111/amount".set_text(str(inventory_stash.get(111)[3]))
	update_crafting()
	update_potions()


func item_picking(id : int):
	$menuclicking.play()
	var in_crafting_slot := false
	if inventory_stash.get(id)[3] > 0:
		for i in crafting_slots:
			if id == i:
				in_crafting_slot = true
		if in_crafting_slot == false:
			crafting_slots.append(id)
			inventory_stash.get(id)[3] -= 1

func update_crafting():
	if crafting_slots.size() >= 1:
		crafting_slot_1.set_texture(load(ingredientslist.get(crafting_slots[0])[2]))
		if crafting_slots.size() >= 2:
			crafting_slot_2.set_texture(load(ingredientslist.get(crafting_slots[1])[2]))
		if crafting_slots.size() == 3:
			crafting_slot_3.set_texture(load(ingredientslist.get(crafting_slots[2])[2]))
		$"crafting button".visible = true
	else:
		$"crafting button".visible = false
		crafting_slot_1.set_texture(load("res://assets/ui/PANELS.PNG"))
		crafting_slot_3.set_texture(load("res://assets/ui/PANELS.PNG"))
		crafting_slot_2.set_texture(load("res://assets/ui/PANELS.PNG"))

func craft_potion():
	for i in potionslist.keys():
		var v :int=0
		for n in crafting_slots:
			var a :Array = []
			if potionslist.get(i)[2].has(n):
				v += 1
		if v == 3 and potions.size() <= 3:
			$potion.pitch_scale = 1
			$potion.play()
			potions.append(i)
			main.potions_brewed_add_one()
			if potionslist.get(i)[0] == "Philosiphers Stone":
				print_debug("you win")
				$win.play()
				$GPUParticles2D.emitting = true
				await get_tree().create_timer(3).timeout
				fade_out_win()
		elif potions.size() > 3:
			tool_tip("Too many potions! Can only hold 3")
		if v == 2:
			$potion.pitch_scale = .5
			$potion.play()
		if crafting_slots.size() < 3:
			tool_tip("You need 3 ingredients to brew")
	crafting_slots.clear()

func tool_tip(Message : String):
	var timer = get_tree().create_timer(2)
	tooltip.set_text(Message)
	timer.timeout.connect(clear_tooltip)
	$menuclicking.pitch_scale = 2.5
	$menuclicking.play()
	$menuclicking.pitch_scale = 0

func clear_tooltip():
	tooltip.set_text(" ")

func update_potions():
	if potions.size() >= 1:
		potion_slot_1.icon = load(potionslist.get(potions[0])[3])
		potion_slot_1.get_popup().set_item_text(0, potionslist.get(potions[0])[0])
		potion_slot_1.get_popup().set_item_text(1, potionslist.get(potions[0])[1])
		if potions.size() >= 2:
			potion_slot_2.icon = load(potionslist.get(potions[1])[3])
			potion_slot_2.get_popup().set_item_text(0, potionslist.get(potions[1])[0])
			potion_slot_2.get_popup().set_item_text(1, potionslist.get(potions[1])[1])
		if potions.size() == 3:
			potion_slot_3.icon = load(potionslist.get(potions[2])[3])
			potion_slot_3.get_popup().set_item_text(0, potionslist.get(potions[2])[0])
			potion_slot_3.get_popup().set_item_text(1, potionslist.get(potions[2])[1])
	else:
		potion_slot_1.icon = load("res://assets/ui/PANELS.PNG")
		potion_slot_3.icon = load("res://assets/ui/PANELS.PNG")
		potion_slot_2.icon = load("res://assets/ui/PANELS.PNG")

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
	tween.tween_property(c, "color",Color.BLACK,1).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(next_level)

func fade_out_win():
	var c :ColorRect= ColorRect.new()
	c.set_anchors_preset(Control.PRESET_FULL_RECT)
	c.color = Color("WHITE",0)
	add_child(c)
	var tween = get_tree().create_tween()
	tween.tween_property(c, "color",Color.WHITE,1).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(game_over)

func game_over():
	main.game_over()

func next_level():
	main.crafting_done(potions)

func _on_100_pressed():
	item_picking(100)


func _on_101_pressed():
	item_picking(101)


func _on_102_pressed():
	item_picking(102)


func _on_103_pressed():
	item_picking(103)


func _on_104_pressed():
	item_picking(104)


func _on_105_pressed():
	item_picking(105)


func _on_106_pressed():
	item_picking(106)


func _on_107_pressed():
	item_picking(107)


func _on_108_pressed():
	item_picking(108)

func _on_109_pressed():
	item_picking(109)


func _on_110_pressed():
	item_picking(110)


func _on_111_pressed():
	item_picking(111)


func _on_next_night_pressed():
	$menuclicking.play()
	fade_out()


func _on_crafting_button_pressed():
	craft_potion()


func _on_potion_1_pressed():
	$menuclicking.play()


func _on_potion_2_pressed():
	$menuclicking.play()


func _on_potion_3_pressed():
	$menuclicking.play()


func _on_menu_button_pressed():
	$papers.play()
