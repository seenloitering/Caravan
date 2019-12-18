extends SuperStructure

class_name Beast

# In Other News
# What do I even need to move into this class that isn't in the base? Cursor keys, for example, should control
# the camel's movement if the player owns it. This should be the default move for testing (a special mode should be for
# control midgets for testing purposes). 

export var constantSpeed: float = 50

# PUBLIC
func get_class(): return "Beast"
func is_class(name): return name == "Beast" or name == "SuperStructure"

func _ready()->void:
	QueryDesk.registerMount(self, ownedBy)
	WalledGarden.createWalledGarden(self)
	velocity = Vector2(constantSpeed,0)

func _physics_process(delta):

	if !self.get_rid():
		print ("Beast: Why don't I have an RID?")
		
	QueryDesk.mainTrack.advanceAlongTrack(self, constantSpeed*delta)

### Functions related to focusing in the UI
func select()->void:
	pass

func deSelect()->void:
	pass

# Called by Captain
func queueAction(a,b):
	pass