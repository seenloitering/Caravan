extends StaticBody2D

func _physics_process(delta):
	##### Cursor stuff on track ####
	var direction_x := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	QueryDesk.mainTrack.advanceAlongTrack(self, direction_x * 500 * delta)
