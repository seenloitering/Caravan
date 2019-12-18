extends StaticBody2D

class_name BodyPart

var superStructure: SuperStructure

func get_class(): return "BodyPart"
const CLASS_NAME = "BodyPart"

func _ready()->void:
	superStructure = findSuperStructureParent()
	if superStructure:
		superStructure.connect("walled", self, "_on_walled")
	else:
		print("BodyPart ERROR: This bodypart has no superStructure")

func findSuperStructureParent()->SuperStructure:
	var parent = get_parent()
	
	# Recursively go back through parents until you run out of parents or find a SuperStructure
	while parent != null:
		if parent.is_class("SuperStructure"):
			return parent
		else:
			parent = parent.get_parent()
	
	return null

func _on_walled()->void: 
	if superStructure:
		WalledGarden.moveToWalledGarden(self, superStructure)
	else:
		WalledGarden.moveToWalledGarden(self)