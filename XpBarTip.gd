extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_player_level_display_xp_growing(xp_position):
	position.x = xp_position - size.x
	show()


func _on_player_level_display_xp_stopped():
	hide()
