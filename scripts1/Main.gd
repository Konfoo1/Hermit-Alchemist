extends Node3D
#LEVEL KEY#
#level_0 = Menu
var level_0 : PackedScene = preload("res://levels/level_0.tscn")
#level_1 = Town: Spawn Location = Vector3(0,1.218,3)
var level_1 : PackedScene = preload("res://levels/level_1.tscn")
#level_2 = Potion Screen
var level_2 := preload("res://levels/level_2.tscn")
var cur_level = 1
var player = preload("res://scenes/player.tscn")
var player_loaded
var level
var difficulty = 1
#Potion Dictionary Format = ID: {Potion Name, Description, [Ingredient ID 1, Ingredient ID 2, Ingredient ID 3], Image}
var potions : Dictionary = {
	0: ["Dash","Allows for a short dash",101,109,110,"res://assets/potions/yellow potion.png"],
	1: ["Speed","Increase your tiny legs speed",101,102,110,"res://assets/potions/orange potion.png"],
	2: ["Double Jump","Conjuours solid air underneath your feet to reach high areas",101,105,110,"res://assets/potions/red potion.png"],
	3: ["Light","Emit a small amount of light, at the cost of what little stealth you already had",106,108,110,"res://assets/potions/white potion.png"],
	4: ["Darkness","Throw at lamps to absorb all light",100,101,107,"res://assets/potions/potion.png"],
	5: ["Invisibility","As you can see ... they cannot",100,101,109,"res://assets/potions/Invisibility potion.png"],
	6: ["Sleep Dart","Knocks out recipiant for 30 seconds",104,107,108,"res://assets/potions/purple potion.png"],
	7: ["Goblin Eye","Your eyes become an uncomfortable green color which alows you to see ingredients better",102,105,106,"res://assets/potions/green potion.png"],
	8: ["Wild Growth©","Causes plants or vines to rapidly grow",100,104,107,"res://assets/potions/brown potion.png"],
	9: ["Time Freeze","Freeze time for a short period",100,108,109,"res://assets/potions/blue potion.png"],
	10: ["Philosiphers Stone","You Did it... yay.",111,109,103,"res://assets/potions/stone.png"]
	}
var tp : Dictionary = {
	0: ["Dash","Allows for a short dash",101,109,110,"res://assets/potions/yellow potion.png"],
	1: ["Speed","Increase your tiny legs speed",101,102,110,"res://assets/potions/orange potion.png"],
	2: ["Double Jump","Conjuours solid air underneath your feet to reach high areas",101,105,110,"res://assets/potions/red potion.png"],
	3: ["Light","Emit a small amount of light, at the cost of what little stealth you already had",106,108,110,"res://assets/potions/white potion.png"],
	4: ["Darkness","Throw at lamps to absorb all light",100,101,107,"res://assets/potions/potion.png"],
	5: ["Invisibility","As you can see ... they cannot",100,101,109,"res://assets/potions/Invisibility potion.png"],
	6: ["Sleep Dart","Knocks out recipiant for 30 seconds",104,107,108,"res://assets/potions/purple potion.png"],
	7: ["Goblin Eye","Your eyes become an uncomfortable green color which alows you to see ingredients better",102,105,106,"res://assets/potions/green potion.png"],
	8: ["Wild Growth©","Causes plants or vines to rapidly grow",100,104,107,"res://assets/potions/brown potion.png"],
	9: ["Time Freeze","Freeze time for a short period",100,108,109,"res://assets/potions/blue potion.png"],
	10: ["Philosiphers Stone","You Did it... yay.",111,109,103,"res://assets/potions/stone.png"]
	}
#Ingredient Dictionary Foramt = ID : [Ingredient, Description, Image, amount]
var inventory_stash : Dictionary = {
	100: ["Soiled Dirt","Tainted Dirt","res://assets/Ingredients/soileddirt.png",0],
	101: ["Crows Feather","Dark and Shiny","res://assets/Ingredients/crows feathers.png",0],
	102: ["Gold Nugget","We're RICH!","res://assets/Ingredients/goldnugget.png",0],
	103: ["Diamond","ooOOoo Shiny!","res://assets/Ingredients/DIAMOND.png",0],
	104: ["Untrimed Bush","Needs a trim","res://assets/Ingredients/untrimmedbush.png",0],
	105: ["Silver coin","Small Dulled Coin","res://assets/Ingredients/SILVER COIN.png",0],
	106: ["Copper Coin","Small Brown Coin","res://assets/Ingredients/COPPER COIN.png",0],
	107: ["Mushrooms","... do NOT eat...","res://assets/Ingredients/MUSHROOMS.png",0],
	108: ["Candle Flame","How did y-","res://assets/Ingredients/CANDLE FLAME.png",0],
	109: ["Golden Feather","Gold and even more shiny","res://assets/Ingredients/GOLDEN FEATHERS.png",0],
	110: ["Toad","Covered in Warts","res://assets/Ingredients/FROG.png",0],
	111: ["Shadow Crystal","Crystal With Swirling Clouds of Smoke","res://assets/Ingredients/SHADOWCRYSTAL.png",0]
	}
var caught_number :int=0
var night_number :int= 1
var potions_brewed :int=0
var ingredients_collected :int=0
var potions_used :int=0
# Called when the node enters the scene tree for the first time.
func _ready():
	level_select(1)

func player_spawn():
	if cur_level == 0:
		pass
	elif cur_level == 1:
		var p = player.instantiate()
		%Player.add_child(p)
		player_loaded = p
	elif cur_level == 2:
		pass
	player_loaded.unhide_ui()

func level_select(next_level : int):
	cur_level = next_level
	if %Cur_level.get_children().size() >= 1:
		%Cur_level.get_child(0).queue_free()
	if cur_level == 0:
		%Cur_level.add_child(level_0.instantiate())
	elif cur_level == 1:
		%Cur_level.add_child(level_1.instantiate())
		player_spawn()
		night_number += 1
		player_loaded.global_position = Vector3(0,1.218,3)
	elif cur_level == 2:
		%Cur_level.add_child(level_2.instantiate())
		%Player.get_child(0).queue_free()
	

func game_over():
	level_select(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func player_caught():
	player_loaded.player_caught()
	caught_number +=1

func player_exfil(Inventory : Dictionary):
	for i in Inventory:
		inventory_stash.get(i)[3] += 1
	level_select(2)
	player_loaded.hide_ui()

func get_inventory_stash():
	return inventory_stash

func crafting_done(potions : Array):
	level_select(1)
	player_loaded.set_potion_inventory(potions)
	player_loaded.unhide_ui()

func get_night_number():
	return night_number

func potions_brewed_add_one():
	potions_brewed += 1
func ingredients_collected_add_one():
	ingredients_collected += 1
func potions_used_add_one():
	potions_used += 1
func get_potions_brewed():
	return potions_brewed
func get_caught_number():
	return caught_number
func get_ingredients_collected():
	return ingredients_collected
func get_potions_used():
	return potions_used
