extends RigidBody2D

signal markLocations

export (int) var speed = 200
var platform = false

# Declare member variables here.
var target = Vector2()
var velocity = Vector2()

# vars for launchTragectory
var maxRange = 900 # Can't jump to things farther away than this
var hangtimePerUnit = 300 # how long this guy should spend in the air--used to calculate launch/jump vector

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true)
	target = global_position;


# Debugging this!
# okay, I need some more feedback: an onscreen coordinate marker. A dot and a label for the current active target and...
# trajectory arcs drawn including labels for origin and target. Also, parabola information like: the maximum value
# Also, trail the movement of objects around the screen.
# Given a moving target and origin projectile (and an apex?), calculate the vector2D and force needed to jump plesantly to the target
func launchTragectory(projectile, target):
	#print("### launchTragectory(projectile, target): ", projectile, " to ", target)
	var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	var totalDisplacement = target - projectile

	## Hangtime
	# the hangtime should be proportionate to the total displacement.
	# The first number is for jumping to higher elevations and the second is for lower
	var displacementPerSecond = 250
	var hangtime = totalDisplacement.length()/displacementPerSecond
	hangtime = 1.5


	# Project moving objects into the future.
	

	if (totalDisplacement.length() >= maxRange):
		print("Out of range. (", totalDisplacement.length(), ")")
		return Vector2()

	# Here's the Parabolic jump code.
	var Vox = (target.x - projectile.x) / hangtime
	var Voy = (target.y + 0.5 * -gravity * hangtime * hangtime - projectile.y) / hangtime

	# Return a vector2 describing the force needed to hit the moving target
	return Vector2(Vox, Voy)

func _on_World_setTarget(target):
	# Animate and destroy a target on screen to show what has been targeted
	var JumpVector = launchTragectory(global_position, target)
	apply_impulse(Vector2(), JumpVector)
	emit_signal("markLocations", {"Jump": position, "Jump Target": target})
