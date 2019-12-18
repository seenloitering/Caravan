extends Object

class_name Target
# Really, a target is a kind of action. This class could have been called Action and maybe it should have been.

const types: Dictionary = {
		"MOVE": 0, # If we don't yet know the means of transport
		"JUMP": 1,
		"RUN": 2,
		"OPERATE": 3
	}

var vector: Vector2 # The global target coords at the time of targetting
var offset: Vector2 # This is the offset within node (so moves relative to the node)
var node: Node2D # The targetted Node
var customFlags: Dictionary # Use this to store any custom values needed by whatever handles this action
var type: int = 0 # goes with enum types. Assume everything is a move instruction to start.
var pending: bool = true # actions are pending until are underway. Assuming that once completed, they'll be deleted

var velocifyingParent: Node2D # The World or Beasts - used for interpolation for jumpers

func _init(aNode: Node2D=null):
	node = aNode

func setVector(aVector: Vector2):
	vector = aVector
	
func generateOffset()->void:
	offset = node.to_local(vector)

func getVelocity()->Vector2:
	if velocifyingParent: return velocifyingParent.velocity
	
	if node == null:
		return Vector2(0,0)
	
	# loop through parents searching for something with velocity
	var parent = node.get_parent()
	while true:
		
		if "velocity" in parent:
			velocifyingParent = parent
			break
		if parent == parent.get_tree().get_root():
			return Vector2(0,0)
		
		parent = parent.get_parent()
	
	return velocifyingParent.velocity
