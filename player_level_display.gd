extends Node2D

signal xp_growing(xp_position)
signal xp_stopped()

var bar_length = 272
var old_xp_required = 0
var xp_required = 100
var level_queue = []
var level_animation = false
var xp_animation = false
var new_xp_animation
var framerate = 12
var physics_frame_count = 0
var new_xp_frames = []
var xp_frames = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$XpBar.size.x = 0
	$NewXpBar.size.x = 0

func _physics_process(delta):
	physics_frame_count += 1
	if physics_frame_count >= (1 / delta) / framerate:
		if xp_animation:
			animate_xp()
		elif level_animation:
			animate_level()
		physics_frame_count = 0

func animate_xp():
	if new_xp_animation:
		animate_new_xp()
	else:
		$XpBar.size.x = (xp_frames.pop_front() - old_xp_required / xp_required) * bar_length
		if (xp_frames.size() == 0):
			xp_animation = false
	
func animate_new_xp():
	var length = new_xp_frames.pop_front()
	$NewXpBar.size.x = (length - old_xp_required / xp_required) * bar_length
	xp_frames.push_back(length)
	if (new_xp_frames.size() == 0):
		new_xp_animation = false

func animate_level():
	$LevelDisplay.text = str("Level: ", level_queue.pop_front())
	if (level_queue.size() == 0):
		level_animation = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_xp(old, new):
	generate_xp_frames(old, new)
	new_xp_animation = true
	xp_animation = true
	
func generate_xp_frames(old, new):
	var frames = framerate / 2
	var lengths = (old - new) / frames
	for i in range(1, frames - 1):
		new_xp_frames.push_back(old + lengths * i)
	new_xp_frames.push_back(new)

func add_level_up(level, new_required):
	level_queue.push_back(level)
	old_xp_required = xp_required
	xp_required = new_required
	level_animation = true
	
func redraw_xp():
	pass
