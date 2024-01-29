extends Node2D

var level_queue = []
var animate = false
var framerate = 12
var physics_frame_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	physics_frame_count += 1
	if animate and physics_frame_count >= (1 / delta) / framerate:
		$LevelDisplay.text = str("Level: ", level_queue.pop_front())
		if (level_queue.size() == 0):
			animate = false
		physics_frame_count = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func add_xp(old, new):
	pass

func add_level_up(level, new_required):
	level_queue.push_back(level)
	animate = true
	
func redraw_xp():
	pass
