extends Node2D

var level_queue = []
var level
var xp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
	
func add_xp(old, new):
	pass

func add_level_up(level, new_required):
	$Level.text = level
	
func redraw_xp():
	pass
