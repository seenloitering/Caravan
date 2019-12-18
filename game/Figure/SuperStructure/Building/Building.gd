extends SuperStructure

class_name Building
# A StaticBody2D that hangs off a Monster like a ship


# PUBLIC
func get_class(): return "Building"

func _ready()->void:
	ownedBy = discoverMyOwner()
	QueryDesk.registerMount(self, ownedBy) 
	WalledGarden.createWalledGarden(self)

# Maybe this should be depricated when I start adding objects programatically
func discoverMyOwner():
	# loop through parents until you find PhysicsBody2D with an ownedBy variable and adopt that id. If none, belong to 0
	var lastParent = get_parent()
	while true:
		if lastParent == get_tree().get_root():
			return 0
		if "ownedBy" in lastParent:
			return lastParent.ownedBy
			
		lastParent = lastParent.get_parent()
