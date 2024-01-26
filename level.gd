extends Node

signal xp_changed(old, new)
signal leveled_up(level, new_required)

@export var level = 0
@export var xp = 0
@export var ratio = 1.1

var previous_required_xp = 0
@export var required_xp = 100

func add_xp(amount):
	if amount > 0:
		xp += amount
		xp_changed.emit(xp - amount, xp)
		check_level_up()
	
func check_level_up():
	while xp > required_xp:
		var old_level = level
		level_up()

func level_up():
	var temp = get_next_required_xp()
	previous_required_xp = required_xp
	required_xp = temp
	level += 1
	leveled_up.emit(level, required_xp)
	
func get_next_required_xp():
	return ((required_xp - previous_required_xp) * ratio) + required_xp

# Called when the node enters the scene tree for the first time.
func _ready():
	leveled_up.emit(level, required_xp)
	xp_changed.emit(xp, xp)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
