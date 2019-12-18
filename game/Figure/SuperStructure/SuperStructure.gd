extends StaticBody2D

class_name SuperStructure

signal walled

const isAlsoASuperStructure:bool = true

export (int) var ownedBy: int = 0
var velocity = Vector2(0,0) # Eventually this should be calculated from its movement and trajectory
var myWalledGarden:int

# PUBLIC
func get_class(): return "SuperStructure"

func _ready()->void:
	pass

# Interface to WalledGarden
func setWalledGarden(a2DSpace:RID)->void:
	# CollisionObject2Ds are in charge of moving themselves in and out of this walledGarden
	# the signal is so that children can know to attach themselves to the current Walledgarden (or not, if that's their thing)
	myWalledGarden = a2DSpace.get_id()
	self.emit_signal("walled")

### Functions related to focusing in the UI
func select()->void:
	pass

func deSelect()->void:
	pass

# Called by Captain
func queueAction(a,b):
	pass