extends Node

class_name Jump

var MathUtils = load("res://Scripts/MathUtils.gd").new()
var landing:bool = false

# Initialize the state. E.g. change the animation
func enter()->void:
	pass

# Clean up the state. Reinitialize values like a timer
func exit()->void:
	landing = false

func handle_input(event)->void:
	pass

func update(delta, c:Critter)->void:
	var walledGardenTarget = null
	
	if (c.orders.size() and c.orders[0].types["MOVE"] == c.orders[0].type):
		# if we're at the target return to IDLE
		# if we need to jump, start that process
		if c.is_grounded && landing:
			landing = false
			c.is_jumping = false
			c.accomplishedOrder()
			c.changeState($"../Idle")
			return
		
		# make the jump
		if c.is_grounded && !c.is_jumping && !landing:
			
			# make the arc height of the jump a function of how along the x we're jumping
			var arc_height = abs((c.orders[0].vector.x - c.global_position.x) / 3)+50
			# roughly interpolate moving targets
			#var interpolatedTarget:Vector2 = c.orders[0].vector + c.orders[0].node.velocity
			var interpolatedTarget:Vector2 = c.orders[0].vector + c.orders[0].getVelocity()
			# Figure out the trajectory of the Critter as a jumping projectile
			c.velocity = MathUtils.calculate_arc_velocity(c.global_position, interpolatedTarget, arc_height)
			c.is_jumping = true
		
		if landing || c.is_jumping:
			c.velocity.y += c.gravity * delta
			
			if c.velocity.y >= 0: # switches to a sort of controlled falling
				c.is_jumping = false
				if !landing:
					
					if "superStructure" in c.orders[0].node:
						walledGardenTarget = c.orders[0].node.superStructure
					WalledGarden.moveToWalledGarden(c, walledGardenTarget)
				landing = true
			
			#var snap = Vector2.DOWN * 32 if !c.is_jumping else Vector2.ZERO
			var snap = Vector2.ZERO
			c.velocity = c.move_and_slide_with_snap(c.velocity, snap, Vector2(0,-1), false)