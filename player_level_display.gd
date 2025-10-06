extends Node2D

signal xp_growing(xp_position)
signal xp_stopped()

# animation states
enum {ANIM_NONE, ANIM_LEVEL, ANIM_NEW_XP, ANIM_XP}

#length of the xp bar
@export var bar_length = 272

#levels get animated at 1/2 framerate using toggle
@export var framerate = 60
@export var xp_rise_time = 0.3

var current_xp = 0
var new_xp = 0

var old_xp_required = 0
var xp_required = 100

var final_old_xp_required = 0;
var final_xp_required = 0;

var level_queue = []
var anim_status = ANIM_NONE
var physics_frame_count = 0
var new_xp_frames = []
var xp_frames = []

var held_animation = false

var temp_color = Color("5da0ff")

# Called when the node enters the scene tree for the first time.
func _ready():
	$XpBar.size.x = 0
	$NewXpBar.size.x = 0

func _physics_process(delta):
	physics_frame_count += 1
	#animate at a constant framerate
	if physics_frame_count >= (1 / delta) / framerate:
		#which animation to do based on status
		match anim_status:
			ANIM_NEW_XP:
				animate_new_xp()
			ANIM_XP:
				animate_xp()
			ANIM_LEVEL:
				animate_level()
		#reset the frame counter
		physics_frame_count = 0

func animate_xp():
	var size = xp_frames.pop_front()
	$XpBar.size.x = size
	#$XpBar.queue_redraw()
	xp_growing.emit(size)
	#if we are finished animating the xp
	if level_queue.size() > 0 and xp_frames.size() == 0:
		anim_status = ANIM_LEVEL
		temp_color = $XpBar.get_theme_stylebox("panel").bg_color
		$XpBar.get_theme_stylebox("panel").bg_color = Color("a0c2ff")
		#after this we will be coming back to this function
	elif xp_frames.size() == 0:
		#set the current xp to new value and we are done animating for now
		xp_stopped.emit()
		current_xp = new_xp
		anim_status = ANIM_NONE
		# check if we got another animation do do during the previous one
		if held_animation:
			held_animation = false
			#temporarily speed up animation to avoid graphical issues
			'''
			#Don't think this is needed anymore
			var temp = xp_rise_time
			xp_rise_time = 0.1
			add_xp(new_xp)
			xp_rise_time = temp
			'''
	
func animate_new_xp():
	xp_stopped.emit()
	var frame = new_xp_frames.pop_front()
	$NewXpBar.size.x = frame
	#$NewXpBar.queue_redraw()
	xp_frames.push_back(frame)
	if new_xp_frames.size() == 0:
		anim_status = ANIM_XP
	#use the new_xp_frames to animate, then put them in the xp_frames
	
func animate_level():
	$LevelDisplay.text = str("Level: ", level_queue.pop_front())
	#if we are finished animating the level ups
	if (level_queue.size() == 0):
		# set xp bar back to zero for final animation
		$XpBar.get_theme_stylebox("panel").bg_color = temp_color
		$XpBar.size.x = 0
		$NewXpBar.size.x = 0
		#$NewXpBar.queue_redraw()
		#$XpBar.queue_redraw()
		current_xp = final_old_xp_required
		#set the xp range correctly
		xp_required = final_xp_required
		old_xp_required = final_old_xp_required
		# generate new frames and animate the xp rise to current
		generate_xp_frames(false)
		anim_status = ANIM_NEW_XP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#try not to do this too often to keep animation smooth
func add_xp(new):
	new_xp = new
	if anim_status == ANIM_NONE:
		if level_queue.size() > 0:
			#generate a full xp animation
			generate_xp_frames(true)
			anim_status = ANIM_NEW_XP
		# this will be our last animation
		else:
			generate_xp_frames(false)
			anim_status = ANIM_NEW_XP
	elif anim_status == ANIM_NEW_XP or anim_status == ANIM_XP:
		#save most recent value to animate at end
		#this makes spammed xp increases not lock up the animation
		held_animation = true
	
func generate_xp_frames(full):
	var num_frames = framerate * xp_rise_time
	#should only be full once per animation cycle
	if full:
		#we want to increase from current num_frames times and reach 100%
		var distance_to_full = xp_required - current_xp
		var percentage_to_full = float(distance_to_full) / float(xp_required - old_xp_required)
		var current_percentage = 1.0 - percentage_to_full
		var percentage_increase_per_frame = percentage_to_full / num_frames
		#generate all frames but the last one
		for i in range(1, num_frames - 1):
			var frame_percentage = current_percentage + (percentage_increase_per_frame * i)
			var frame_size = bar_length * frame_percentage
			new_xp_frames.push_back(frame_size)
		#generate last frame precisely
		new_xp_frames.push_back(bar_length)
	else:
		#increase from current num_frames times and reach new percentage
		var current_percentage = float(current_xp - old_xp_required) / float(xp_required - old_xp_required)
		var new_percentage = float(new_xp - old_xp_required) / float(xp_required - old_xp_required)
		var percentage_distance = new_percentage - current_percentage
		var percentage_increase_per_frame = percentage_distance / num_frames
		#generate all frames but the last one
		for i in range(1, num_frames - 1):
			var frame_percentage = current_percentage + (percentage_increase_per_frame * i)
			var frame_size = bar_length * frame_percentage
			new_xp_frames.push_back(frame_size)
		#generate last frame precisely
		new_xp_frames.push_back(bar_length * new_percentage)

func add_level_up(level, old_required, new_required):
	#levels being on the queue will cause the state to be adjusted from xp animations
	level_queue.push_back(level)
	# we don't want to change the XP display until after we finish the level up animation
	final_old_xp_required = old_required
	final_xp_required = new_required
