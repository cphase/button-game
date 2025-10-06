extends Node2D

signal mined_something(item)

var mining = false
var items = {"Stone, Coal, Iron, Gold, Diamond"}
var item_chances = {0.5, 0.3, 0.2, 0.1, 0.01}
var mining_speed = 1
var mining_multiplier = 1
#figure out how chances work with pick and levels

var physics_frame_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	physics_frame_count += 1
	#animate at a constant framerate
	if physics_frame_count >= (1 / delta) / mining_speed:
		if mining:
			$MinePanel/MinedItemsLabel.text = str($MinePanel/MinedItemsLabel.text, "hello\n")
		physics_frame_count = 0
	
func _on_button_toggled(toggled_on):
	mining = toggled_on
