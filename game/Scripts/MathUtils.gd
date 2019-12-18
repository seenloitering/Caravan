# Library with Math and vector utilities

class_name MathUtils

static func calculate_arc_velocity(point_a, point_b, min_arc, \
		up_gravity = ProjectSettings.get_setting("physics/2d/default_gravity"), \
		down_gravity = ProjectSettings.get_setting("physics/2d/default_gravity") )->Vector2:
	
	# Guarentees that arc_height is high enough
	# The arc_height needs to be higher than the y displacement of point a and point b 
	# arc_height has to be equal or less than 0	
	var arc_height = point_b.y - point_a.y - min_arc
	arc_height = min(arc_height, -1 * min_arc)
	
	var velocity = Vector2()
	
	var displacement = point_b - point_a
	var arc = 2
	
	var time_up = sqrt((-1*arc) * arc_height / float(up_gravity))
	var time_down = sqrt(arc * (displacement.y - arc_height) / float(up_gravity))
	
	velocity.y = -sqrt((-1*arc) * up_gravity * arc_height)
	velocity.x = displacement.x / float(time_up + time_down)
	
	return velocity

# This function gives a Vector whose displacement is sufficient to move the projectile to the target along a parabolic arc in hangtime
func getTragectoryVector(projectile, target, hangtime=.8, gravity=ProjectSettings.get_setting("physics/2d/default_gravity")):
	
	# Maybe some error checking here. Do projectile and target *really* have coords? 
	
	var Vox = (target.x - projectile.x) / hangtime
	var Voy = (target.y + 0.5 * -gravity * hangtime * hangtime - projectile.y) / hangtime

	# Return a vector2 describing the force needed to hit the moving target
	return Vector2(Vox, Voy)

# Given aPoint and two opposing corners of a rectangle, does the point intercept?
func isVectorInARect(aPoint, pointA, pointC)->bool:
	if aPoint.x > min(pointA.x, pointC.x) and aPoint.x < max(pointA.x, pointC.x):
		if aPoint.y > min(pointA.y, pointC.y) and aPoint.y < max(pointA.y, pointC.y):
			return true
	return false