extends Node2D

signal mined_something(item)

var mining = false
var item_chances = {}
#figure out how chances work with pick and levels

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if mining:
		pass

func _on_button_toggled(toggled_on):
	mining = toggled_on
