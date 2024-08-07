extends Control
@onready var main := get_node("/root/Main")
var night_number :int
var caught_number :int
var potions_brewed :int
var ingredients_collected :int
var potions_used :int
@onready var night_number_label :Label= $MarginContainer2/HBoxContainer/VBoxContainer/nightsstat
@onready var caught_number_label :Label=$MarginContainer2/HBoxContainer/VBoxContainer/GridContainer/caught_number
@onready var potions_brewed_label :Label=$MarginContainer2/HBoxContainer/VBoxContainer/GridContainer/potions_brewed
@onready var ingredients_collected_label :Label=$MarginContainer2/HBoxContainer/VBoxContainer/GridContainer/ingredients_collected
@onready var potions_used_label :Label=$MarginContainer2/HBoxContainer/VBoxContainer/GridContainer/potions_used

# Called when the node enters the scene tree for the first time.
func _ready():
	night_number = main.get_night_number()
	caught_number = main.get_caught_number()
	potions_brewed = main.get_potions_brewed()
	ingredients_collected = main.get_ingredients_collected()
	potions_used = main.get_potions_used()
	
	night_number_label.set_text(str(night_number) + " Nights!")
	caught_number_label.set_text(str("Caught "+str(caught_number)+" Nights"))
	potions_brewed_label.set_text(str(str(potions_brewed)+" Potions Brewed"))
	ingredients_collected_label.set_text(str("Collected "+str(ingredients_collected)+" Ingredients"))
	potions_used_label.set_text(str("Used "+str(potions_used)+" Potions"))
	await get_tree().create_timer(15).timeout
	get_tree().change_scene_to_file("res://levels/Start_Screen.tscn")

