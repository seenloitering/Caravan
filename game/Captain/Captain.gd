extends Node2D

#class_name Captain

export var callsign: String = "A Name"

var selectedObjects: Array = Array()
var targetQueue = Array() # This can focus on different sorts of objects so is untyped
var currentAction = null

# Variables managed by QueryDesk
export var captainID:int = 0

func _ready()->void:
	captainID = QueryDesk.registerCaptain(self, captainID)

# Keep in mind that what's discovered here may be following instructions for an AI, interface, or from a server
func _physics_process(delta):
	# Are there target actions in the queue
	if (!currentAction and targetQueue.size()): # What's this currentAction business?
		# remove from queue to handle
		var aTarget: Target = targetQueue.pop_front()
		
		# if a target object hasn't been set yet, convert the vector
		if !aTarget.node and aTarget.vector:
			# Check first if this location intersects with something to act on
			moveTargetToNextSurface(aTarget)
			if !aTarget.node:
				aTarget.node = get_tree().get_root().get_node("World")
			aTarget.generateOffset()
			# send instructions to focused peons
			if (selectedObjects.size()):
				for i in range(selectedObjects.size()):
					selectedObjects[i].node.queueAction(aTarget, "MOVE")
			else:
				print("Captain._physics_process:No focus to target")
			
		elif aTarget.node and !aTarget.vector:
			print("Captain: We have a node with an unknown vector")
		else:
			print("Captain: Got a bad target for some reason")
	

# Always called from _physics_process
func moveTargetToNextSurface(aTarget: Target)->void:
	#print("Captain.moveTargetToNextSurface")
	var fromPoint: Vector2 = aTarget.vector
	var space_state = get_world_2d().direct_space_state
	# Are we intersecting a platform already? Change this so it uses collision masks
	#var result = space_state.intersect_point(fromPoint, 1, Array(), 2^3)
	var result = WalledGarden.intersect_point_AcrossGardens(fromPoint, 1, Array(), 2^3)
	
	# if not over a platform, ray down until you hit a platform providing both a target and a position
	if (!result.size()):
		#var anotherResult = space_state.intersect_ray(fromPoint, Vector2(fromPoint.x, fromPoint.y + 2000), Array(), 2^3)
		var anotherResult = WalledGarden.intersect_ray_AcrossGardens(fromPoint, Vector2(fromPoint.x, fromPoint.y + 2000), Array(), 2^3)
		if(anotherResult):
			# Is this still INSIDE the platform?
			aTarget.node = anotherResult.collider
			aTarget.vector = anotherResult.position
			#return anotherResult.position
		else:
			print("Why didn't I find a platform?! 1")
			
	# if already inside a platform, then what? get the top edge of the current collider and ray down to it using intersect_point_on_canvas .
	else:
		# For the ray here. Instead, skip up 20px at a time until you no longer intersect, then guess at halves again

		var theTarget = result[0].collider
		var theTargetInstanceID = theTarget.get_instance_id()
		var newCastOrigin = fromPoint
		newCastOrigin.y -= 20

		# Loop until you leave this platform
		while (1):
			# test for intersection with this
			#result = space_state.intersect_point_on_canvas(newCastOrigin, theTargetInstanceID, 32, Array(),2^3)
			result = WalledGarden.intersect_point_on_canvas_AcrossGardens(newCastOrigin, theTargetInstanceID, 32, Array(),2^3)
			# if intersection, break
			if (result):
				newCastOrigin.y -= 20
			else:
				break
			
		#result = space_state.intersect_ray(newCastOrigin, fromPoint, Array(), 2^3)
		result = WalledGarden.intersect_ray_AcrossGardens(newCastOrigin, fromPoint, Array(), 2^3)
		if (result):
			aTarget.node = theTarget
			aTarget.vector = result.position
		else:
			print("Why didn't I find a platform?! 2")


# Selection Handling functions
func _add_selection(anObject:Object)->void:
	selectedObjects.append(anObject)
	anObject.node.select()

func _remove_selection(anObject:Object)->void:
	# if this object is already selected, just leave it
	for i in range(selectedObjects.size()):
		if selectedObjects[i] == anObject:
			selectedObjects.remove(i)
			selectedObjects[i].node.deSelect()

func _clear_selection()->void:
	for i in range(selectedObjects.size()):
		selectedObjects[i].node.deSelect()
	selectedObjects = Array()

func target(anObject)->void:
	targetQueue.append(anObject)

### Getters and Setter for Godot inspector
func _get(property):
	if property == "callsign":
		return callsign 

func _set(property, value):
	if property == "callsign":
		callsign = value 
		return true

func _get_property_list():
	return [
		{
			"hint": PROPERTY_HINT_NONE,
			"usage": PROPERTY_USAGE_DEFAULT,
			"name": "callsign",
			"type": TYPE_STRING
		}
	]
