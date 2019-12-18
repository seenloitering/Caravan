extends Node2D

class_name Track

# What's a race without a Track? Each level has it's own main track, but a race can have alternate routes (and there should be portends
# to make that happen. This object serves as an interface to the tracks in a race (a level).

# TODO
# - integrate FollowHandler object so that Track to act as a factory for it, handing them out to creatures placed on the track. Avoids all these loops
# - the simplest version of this is to maintain a Dictionary indexed by nodepaths
var remotes:Dictionary = Dictionary() # indexed by Monster OR Creature nodePath (the follower is always the parent of the remote)

# PUBLIC
func get_class(): return "Track"

# PUBLIC. For platforms who will be moving directly on the track (as opposed to creatures)
func add_toTrack(aMonster)->void:
	var aFollow:PathFollow2D = PathFollow2D.new()
	$Path2D.add_child(aFollow)
	if remotes.has(aMonster.get_path()):
		remove_fromTrack(aMonster)
	add_follower(aMonster, aFollow)

# PUBLIC. For creatures who want to inherit a monster's movement because they're embarked
func start_following(aFollower, aMonster)->void:
	print("start_following(", aFollower, ", ", aMonster, " - ", aMonster.get_path())
	# get the Follow parent of aMonster's RemoteTransform2D
	var aFollow:PathFollow2D = remotes[aMonster.get_path()].get_parent()
	if remotes.has(aFollower.get_path()):
		remove_follow(aFollower)
	add_follower(aFollower, aFollow)

# PUBLIC. Get monsters off a track and cleanup after them
func remove_fromTrack(aMonster)->void:
	var rt:RemoteTransform2D = remotes[aMonster.get_path()]
	remove_asChildNode(rt.get_parent())
	remove_asChildNode(rt)
	remotes.erase(aMonster.get_path())

# PUBLIC. creatures who want to disembark
func remove_follow(aNode)->void:
	if remotes.has(aNode.get_path()):
		var rt:RemoteTransform2D = remotes[aNode.get_path()]
		remove_asChildNode(rt)
		remotes.erase(aNode.get_path())

# PUBLIC. Must be used in _physics_process; negative values move backward along track
func advanceAlongTrack(aMonster, aValue:float)->void:
	if !remotes.has(aMonster.get_path()):
		return
	var f:PathFollow2D = remotes[aMonster.get_path()].get_parent()
	if f:
		# Add aValue distance to the current offset along the track
		f.set_offset(f.get_offset() + aValue)

# PRIVATE. used to add either monsters or creatures to a PathFollow2D
func add_follower(aFollower, aFollow: PathFollow2D)->void:
	var rt:RemoteTransform2D =  RemoteTransform2D.new()
	aFollow.add_child(rt)
	rt.set_remote_node(aFollower.get_path())
	remotes[aFollower.get_path()] = rt

# PRIVATE. the dirty work of freeing up any child node
func remove_asChildNode(someChildNode)->void:
	#var pf: PathFollow2D = someChildNode.get_parent()
	someChildNode.get_parent().remove_child(someChildNode)
	someChildNode.queue_free()

