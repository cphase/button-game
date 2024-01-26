extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	$Level.xp_changed.connect($PlayerLevelDisplay.add_xp.bind())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_add_xp_pressed():
	$Player.Level.add_xp(50)
