extends SuperStructure

class_name Ground

# Declare member variables here.
var target: Vector2 = Vector2()
var platform: bool = true
var crew: Array = Array()
var superStruture

# PUBLIC
func get_class(): return "Ground"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_pickable(true)
	velocity = Vector2(0,0)
	#QueryDesk.registerCreature(self, ownedBy) Why was this ever set to register, much less register as a creature?!?!


func _input(event):
	return
	if event is InputEventMouseButton:
		target = get_global_mouse_position()
		get_tree().set_input_as_handled()

func queueAction(anAction,typeOf="IMPLICIT")->void:
	pass
	
func select()->void:
	pass

func deSelect()->void:
	pass