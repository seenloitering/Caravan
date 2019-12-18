extends Node

class_name Idle

# Initialize the state. E.g. change the animation
func enter()->void:
	pass

# Clean up the state. Reinitialize values like a timer
func exit()->void:
	pass

func handle_input(event)->void:
	pass

func update(delta, c:Critter)->void: # c is the Context of the State machine
	# If I'm in the air, fall
	if !c.is_grounded:
		c.changeState($"../Fall")
	
	# Check orders and change state if needs be
	if (c.orders.size() and c.orders[0].types["MOVE"] == c.orders[0].type):
		# Pathfind the difference between jump and run
		c.changeState($"../Jump")
		#c.changeState($"../Run")
	
	# if I'm landed somewhere, just play the animation and hang out.
	
