extends Node

#class_name QueryDesk
# This is a mediator class for crews, capitains, and mounts. It manages their interactions and maintain exclusion lists for collision.


var hauls: Array = Array()

### Ideas at work here
# There are captains, crews and mounts.
# Layers are set so only interaction between crews and mounts needs exception handling.
# both crews AND mounts may need their own acception lists, so impliment tham all for now.
# lists should be created as part of the registration process and removed as part of the deregistration process
# consider using RID for unique ID

# TODO: change language to use captains/critters/(monsters)
# This library maintains a database of captains, monsters and midgets and who they belong to
var captains: Dictionary = Dictionary() # indexed by the captain's unique ID and contains a link to its object
var creatures: Dictionary = Dictionary() # indexed by the creatures unique ID
var mounts: Dictionary = Dictionary() # indexed by the Monster's unique ID

var masterListOfCrew: Array = Array()
var masterListOfMounts: Array = Array()

var inputCaptainID = 1

# Singleton access to levels and tracks and stuff
var mainTrack: Track

# Called when the node enters the scene tree for the first time.
func _ready():
	captains["0"] = "World"

func registerCaptain(anObject, anID = null)->int:
	if !anID:
		anID = generateUniqueID(captains)
	captains[anID] = anObject
	return anID

func registerMount(aMount, captainID=0)->void:
	var id = generateUniqueID(creatures)
	aMount.ownedBy = captainID
	mounts[id] = aMount
	masterListOfMounts.append(aMount)
	#registerMountWithExceptionLists(aMount)
	#print("REGISTERED Mount:", aMount,"(", aMount.get_class() ,"), to ",captainID)

func registerCreature(creature, captainID=0)->void:
	var id = generateUniqueID(creatures)
	creature.ownedBy = captainID
	creatures[id] = creature
	masterListOfCrew.append(creature)
	#registerCreatureWithExceptionLists(creature)
	#print("REGISTERED Creature:", creature,"(", creature.get_class() ,"), to ",captainID)

func generateUniqueID(dict)->int:
	var i = 1
	while 1:
		if (!dict.has(i)):
			return i
		i = i+1
	return 0

func getMyCrew(aCaptainID=inputCaptainID)->Array:
	var result = Array()
	for i in creatures.keys():
		if creatures[i].ownedBy == aCaptainID: 
			result.append(creatures[i])
	return result

func inputCaptain(aCaptainID=inputCaptainID):
	return captains[aCaptainID]

##### START Exclusion List functions ####

# Registering creatures and mounts for the first time just means excepting them from every mount
func registerCreatureWithExceptionLists(aCreature)-> void:
	# Loop through mounts adding this crew as an exception
	for i in range(masterListOfMounts.size()):
		masterListOfMounts[i].add_collision_exception_with(aCreature)
		aCreature.add_collision_exception_with(masterListOfMounts[i])

func registerMountWithExceptionLists(aMount)-> void:
	# Loop through crew adding this crew as an exception
	for i in range(masterListOfCrew.size()):
		masterListOfCrew[i].add_collision_exception_with(aMount)
		aMount.add_collision_exception_with(masterListOfCrew[i])

# if the ownership is right, remove this creature from the mount's exception list and vice-versa
func embark(aCreature, aMount)->bool:
	if aMount.get_class() != "Beast": return false
	#if aCreature.ownedBy == aMount.ownedBy: # For now, let everyone embark any mount
	aCreature.remove_collision_exception_with(aMount)
	aMount.remove_collision_exception_with(aCreature)
	return true
	#return false
	
func disembark(aCreature, aMount)->bool:
	if aMount.get_class() != "Beast": return false
	aCreature.add_collision_exception_with(aMount)
	aMount.add_collision_exception_with(aCreature)
	return true

func deregisterCreatureWithExceptionLists(aCreature)-> void:
	for i in range(masterListOfMounts.size()):
		masterListOfMounts[i].remove_collision_exception_with(aCreature)

func deregisterMountWithExceptionLists(aMount)-> void:
	for i in range(masterListOfCrew.size()):
		masterListOfCrew[i].remove_collision_exception_with(aMount)

##### END Exclusion List functions ####