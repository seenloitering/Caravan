extends Node

class_name Fall

# Initialize the state. E.g. change the animation
func enter()->void:
	pass

# Clean up the state. Reinitialize values like a timer
func exit()->void:
	pass

func handle_input(event)->void:
	pass

func update(delta, c:Critter)->void:
	c.velocity.y += c.newGravity
	c.is_jumping = false
	
	var snap = Vector2.ZERO
	c.velocity = c.move_and_slide_with_snap(c.velocity, snap, c.UP, false )
	
	if c.is_grounded:
		c.changeState($"../Idle")