extends Node

@export var level = 0
@export var xp = 0

var previous_required_xp = 0
var required_xp = 100

func add_xp(amount):
	if amount > 0:
		xp += amount
		while check_level_up():
			pass
	
func check_level_up():
	if xp > required_xp:
		level_up()
		return true

func level_up():
	var temp = get_next_required_xp()
	previous_required_xp = required_xp
	required_xp = temp
	level += 1
	
func get_next_required_xp():
	return ((required_xp - previous_required_xp) * 1.1) + required_xp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
