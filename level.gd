extends Node

signal leveled_up(level, old_required, new_required)
signal xp_changed(new)

@export var level = 0
@export var xp = 0
@export var ratio = 1.1

var previous_required_xp = 0
@export var required_xp = 100

func add_xp(amount):
	if amount > 0:
		xp += amount
		#first emit levels up if needed.
		check_level_up()
		xp_changed.emit(xp)
	
func check_level_up():
	while xp >= required_xp:
		level_up()

func level_up():
	var temp = get_next_required_xp()
	previous_required_xp = required_xp
	required_xp = temp
	level += 1
	leveled_up.emit(level, previous_required_xp, required_xp)
	
func get_next_required_xp():
	return ((required_xp - previous_required_xp) * ratio) + required_xp

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_add_xp_pressed():
	add_xp(50)

func _on_add_xp_1000_pressed():
	add_xp(1000)
