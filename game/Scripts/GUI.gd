extends Node2D

# receive keyboard commands and send out signals to listening objects

# Receive click commands and send out signals to listeners.


var target: Vector2 = Vector2()

# If this is ALWAYS at the top of the root, it can capture clicks in empty space. Move into the level!
func _unhandled_input(event):
	return
	if event is InputEventMouseButton:
		target = get_global_mouse_position()
		print ("Passing on Target(GUI):", target)
		# If there's no interface and no object to select, draw a ray down to the first ground or plateform and
		# choose that as a target.
