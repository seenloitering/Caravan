extends Node

#class_name WalledGarden

var walledgardenRIDs: Array = ["reserved"]
var superStructures: Array = Array()

func get_class(): return "WalledGarden"

func _ready()->void:
	# Hopefully, this is the default 2D space get_world_2d() returns no matter what space the object calling it is in
	walledgardenRIDs[0] = get_tree().get_root().get_world_2d().get_space()

func printWalledGardens()->void:
	print("WalledGarden.root:", superStructures[0].get_tree().get_root().get_world_2d().space.get_id())
	for ss in superStructures:
		print("###WalledGarden: ", ss.name, ", ", ss.get_rid().get_id(), \
			" in ", Physics2DServer.body_get_space(ss.get_rid()).get_id())

## This creates a 2D world for Walled Physical Gardens 
# I *suspect* the forObject must be added to the scene tree before this is called
func createWalledGarden(forObject)->void:
	var a2DSpace:RID = Physics2DServer.space_create()
	Physics2DServer.space_set_active(a2DSpace,true)
	mirrorDefaultSpace(a2DSpace, forObject.get_world_2d().get_space())
	# Instead of adding the Beast class, call a function on the beast in which it handle putting its children into the right garden
	# Beasts and Buildings should inherit from the same class
	Physics2DServer.body_set_space(forObject.get_rid(), a2DSpace)
	forObject.setWalledGarden(a2DSpace) # Sends out signal that followers should also switch WalledGarden
	walledgardenRIDs.append(a2DSpace) # This is probably pointless because RIDs don't seem to persist
	
	# Now verify that this actually *is* in a WalledGarden
	#print("###WalledGarden: ", forObject.name, ", ", forObject.get_rid().get_id(), \
	#	" in ", Physics2DServer.body_get_space(forObject.get_rid()).get_id())
	superStructures.append(forObject)

func removeWalledGarden(aWorld:RID):
	Physics2DServer.space_set_active(aWorld,false)
	Physics2DServer.free_rid(aWorld)
	pass

func moveToWalledGardenByRID(bodyRID:RID, spaceRID:RID)->void:
	if !Physics2DServer.body_set_space(bodyRID, spaceRID):
		print("WalledGarden: Move still failing")

# move moveObj to the same walled garden as destObj
# if destObj is null, go to root collision world
func moveToWalledGarden(moveObj, destObj = null):
	var destinationSpace:RID
	if destObj:
		destinationSpace = Physics2DServer.body_get_space(destObj.get_rid()) 
	else:
		destObj = moveObj.get_world_2d() # Default to the root World Space
		print("WalledGarden: This should always break because RIDs are not preserved")
		destinationSpace = walledgardenRIDs[0]
	Physics2DServer.body_set_space(moveObj.get_rid(), destinationSpace)
	# varify that the move happened
	if Physics2DServer.body_get_space(moveObj.get_rid()).get_id() != Physics2DServer.body_get_space(destObj.get_rid()).get_id():
		print("WalledGarden.moveToWalledGarden Failed:", moveObj.get_rid().get_id(), " != ", destObj.get_rid().get_id())
	print("WalledGarden.moveToWalledGarden: ", moveObj.name, " moved to ", destObj.get_rid().get_id())

## Shortcut to get direct physics state
func getGardenState(aSpace:RID)->Physics2DDirectSpaceState:
	return Physics2DServer.space_get_direct_state(aSpace)
	
## Shortcut to get an object's current Garden RID
func getGarden(anRID:RID)->RID:
	return Physics2DServer.body_get_space(anRID)
	
## Shortcut to get an object's State
func getCurrentState(anObject)->Physics2DDirectSpaceState:
	return getGardenState(getGarden(anObject.get_rid()))

func getDefaultGardenState()->Physics2DDirectSpaceState:
	return Physics2DServer.space_get_direct_state(get_tree().get_root().get_world_2d().get_space())

## wrap get_world_2d().direct_space_state
# This wrapper shouldn't be used by anything that makes tons of calls. This is more for target picking. Add These as they're required.
#	intersect_point() - just append all the arrays together
# maybe this should take a list of Garden's to include or exclude?
func intersect_point_AcrossGardens ( point:Vector2, max_results:int=32, exclude:Array=[ ], collision_layer:int=2147483647, collide_with_bodies:bool=true, collide_with_areas:bool=false ) -> Array:
	var collisions:Array = Array()
	var queryResult:Array
	for item in walledgardenRIDs:
		queryResult = getGardenState(item).intersect_point(point, max_results, exclude, collision_layer, collide_with_bodies, collide_with_areas)
		collisions += queryResult
	return collisions

#	intersect_ray()
# What to return here? intersect_ray usualy only resturns one result, I believe, the first collision. 
# Dictionary intersect_ray ( Vector2 from, Vector2 to, Array exclude=[ ], int collision_layer=2147483647, bool collide_with_bodies=true, bool collide_with_areas=false )
func intersect_ray_AcrossGardens(from:Vector2, to:Vector2 , exclude:Array =[ ], collision_layer:int=2147483647, collide_with_bodies:bool=true, collide_with_areas:bool=false )->Dictionary:
	var queryResult:Dictionary
	var bestResultSoFar:Dictionary = Dictionary()
	for item in walledgardenRIDs:
		queryResult = getGardenState(item).intersect_ray(from,to,exclude,collision_layer,collide_with_bodies,collide_with_areas)
		if queryResult:
			if bestResultSoFar.empty():
				bestResultSoFar = queryResult
			else:
				if queryResult.position - from < bestResultSoFar.position - from:
					bestResultSoFar = queryResult
	return bestResultSoFar

#	intersect_point_on_canvas()
# Array intersect_point_on_canvas ( Vector2 point, int canvas_instance_id, int max_results=32, Array exclude=[ ], int collision_layer=2147483647, bool collide_with_bodies=true, bool collide_with_areas=false ) 
func intersect_point_on_canvas_AcrossGardens(point:Vector2, canvas_instance_id:int, max_results:int=32, exclude:Array=[ ], collision_layer:int=2147483647, collide_with_bodies:bool=true, collide_with_areas:bool=false )->Array:
	var collisions:Array = Array()
	var queryResult:Array
	for item in walledgardenRIDs:
		queryResult = getGardenState(item).intersect_point_on_canvas(point, canvas_instance_id, max_results, exclude, collision_layer, collide_with_bodies, collide_with_areas)
		collisions += queryResult
	return collisions


# Do I also need to mirror AreaSpaceOverrideMode and SpaceParameter?
func mirrorDefaultSpace(aNewSpace:RID, defaultSpace:RID)->void:
	var defaultValue = Physics2DServer.area_get_param(defaultSpace, Physics2DServer.AREA_PARAM_GRAVITY)
	Physics2DServer.area_set_param(aNewSpace, Physics2DServer.AREA_PARAM_GRAVITY, defaultValue)
	
	defaultValue = Physics2DServer.area_get_param(defaultSpace, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR)
	Physics2DServer.area_set_param(aNewSpace, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, defaultValue)
	
	defaultValue = Physics2DServer.area_get_param(defaultSpace, Physics2DServer.AREA_PARAM_GRAVITY_IS_POINT)
	Physics2DServer.area_set_param(aNewSpace, Physics2DServer.AREA_PARAM_GRAVITY_IS_POINT, defaultValue)
	
	defaultValue = Physics2DServer.area_get_param(defaultSpace, Physics2DServer.AREA_PARAM_GRAVITY_DISTANCE_SCALE)
	Physics2DServer.area_set_param(aNewSpace, Physics2DServer.AREA_PARAM_GRAVITY_DISTANCE_SCALE, defaultValue)
	
	defaultValue = Physics2DServer.area_get_param(defaultSpace, Physics2DServer.AREA_PARAM_LINEAR_DAMP)
	Physics2DServer.area_set_param(aNewSpace, Physics2DServer.AREA_PARAM_LINEAR_DAMP, defaultValue)
	
	defaultValue = Physics2DServer.area_get_param(defaultSpace, Physics2DServer.AREA_PARAM_ANGULAR_DAMP)
	Physics2DServer.area_set_param(aNewSpace, Physics2DServer.AREA_PARAM_ANGULAR_DAMP, defaultValue)
	
	defaultValue = Physics2DServer.area_get_param(defaultSpace, Physics2DServer.AREA_PARAM_PRIORITY)
	Physics2DServer.area_set_param(aNewSpace, Physics2DServer.AREA_PARAM_PRIORITY, defaultValue)