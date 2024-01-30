extends Node2D

signal xp_growing(xp_position)
signal xp_stopped()

enum {ANIM_NONE, ANIM_LEVEL, ANIM_NEW_XP, ANIM_XP}

@export var bar_length = 272
@export var framerate = 12
@export var xp_rise_time = 0.5

var current_xp = 0
var old_xp_required = 0
var xp_required = 100

var level_queue = []
var anim_status = ANIM_NONE
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
		match anim_status:
			ANIM_NEW_XP:
				animate_new_xp()
			ANIM_XP:
				animate_xp()
			ANIM_LEVEL:
				animate_level()
		physics_frame_count = 0

func animate_xp():
	if level_queue.size() > 0:
		anim_status = ANIM_LEVEL
	else:
		anim_status = ANIM_NONE
	
func animate_new_xp():
	anim_status = ANIM_XP
	
func animate_level():
	$LevelDisplay.text = str("Level: ", level_queue.pop_front())
	if (level_queue.size() == 0):
		#SET XP BAR BACK TO 0
		anim_status = ANIM_NEW_XP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_xp(old, new):
	# check the level queue if we are leveling up
	generate_xp_frames(old, new)
	
func generate_xp_frames(old, new):
	var frames = framerate * xp_rise_time
	#var percentage_per_frame = 

func add_level_up(level, old_required, new_required):
	level_queue.push_back(level)
	old_xp_required = old_required
	xp_required = new_required
