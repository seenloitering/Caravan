# Library with Math and vector utilities

class_name LocalKinematicsUtils

# Whenever there's a collision that results in a Critter standing on something, this function should get called to
# make them a child of that body.
static func landOnABody(agent: Node2D, landing: Node2D)->void:
	pass
	
static func enterOpenSpace(agent: Node2D)->void:
	pass
	
static func getLanding(agent: Node2D)->Node2D:
	return Node2D.new()
	