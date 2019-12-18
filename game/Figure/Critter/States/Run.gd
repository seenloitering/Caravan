extends Node

class_name Run

const SLOPE_STOP_THREHOLD:float = 64.0

# Initialize the state. E.g. change the animation
func enter()->void:
	pass

# Clean up the state. Reinitialize values like a timer
func exit()->void:
	pass

func handle_input(event)->void:
	pass

func update(delta, c:Critter)->void:

	var move_dist = c.orders[0].vector.x - c.global_position.x
	var move_direction = 1 if move_dist > 1 else -1
	if abs(move_dist) < 10:
		c.accomplishedOrder()
		c.changeState($"../Idle")
		return
	elif abs(move_dist) < 1000:
		c.velocity.x = move_dist
	else:
		c.velocity.x = 1000 * move_direction
	if move_direction != 0:
		$"../../Sprite".scale.x = move_direction
	
	#Apply gravity
	if move_direction != 0:
		c.velocity.y += c.gravity
	
		# Turning snapping off so we can jump.
		var snap = Vector2.DOWN * 32
		if move_direction == 0 && abs(c.velocity.x)< SLOPE_STOP_THREHOLD:
			c.velocity.x = 0
	
		var stop_on_slope = false
		c.velocity = c.move_and_slide_with_snap(c.velocity, snap, Vector2(0,-1), stop_on_slope)
		

