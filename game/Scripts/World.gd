extends Node2D

var MathUtils = load("res://Scripts/MathUtils.gd").new()

signal setTarget

var target: Vector2 = Vector2()
var setActiveTarget = null
var focus = null
var setActiveFocus = null
var activeFocuses: Array = Array()

var locationsToMark: Array = Array() # This array gets filled with named arrays containing an arbitrary number of lebeled coords

# Drag selecting variables
var beginSelectBoxPosition: Vector2 = Vector2()
var is_dragging: bool = false
var is_pressed_leftMouse: bool = false

### Notes on collision layers:
#		3 = just ground (the ground is also a platform on layer 1)
#		2 = this is the layer for raycasting Platforms. Apparently, the raycasting mask matches layer masks, rather than layers
#		1 = Frogs
#		0 = Platforms (platforms should also belong to layer 3 for raycasting)

# Called when the node enters the scene tree for the first time.
func _ready()->void:
	target = position
	
	QueryDesk.mainTrack = $AnatolianLevel
	QueryDesk.mainTrack.add_toTrack($Beast)
	WalledGarden.printWalledGardens()

func  _unhandled_input(event)->void:
	var localEvent = make_input_local(event) # event.position are viewport coords while "local" are world coords
	
	# Action event!
	if event.is_action_released("ui_right_mouse_button"):
		target = localEvent.position
		var aTarget = Target.new()
		aTarget.setVector(target)
		# targets override right now, but in the future only do this if shift is held
		QueryDesk.inputCaptain().target(aTarget)

	# Select focus event!
	if event.is_action_released("ui_left_mouse_button"):
		if (!is_dragging):
			setActiveFocus = localEvent.position
			is_pressed_leftMouse = false
		if (is_dragging):
			is_pressed_leftMouse = false
			is_dragging = false
			$DragTest.sizeVector = Vector2()
			$DragTest.update()

	if event.is_action_pressed("ui_left_mouse_button"):
		is_pressed_leftMouse = true
		beginSelectBoxPosition = localEvent.position
		
	if event is InputEventMouseMotion and is_pressed_leftMouse:
		is_dragging = true

func _physics_process(delta):

	var space_state
	
	# We're selecting stuff
	if (is_dragging):
		$DragTest.position = beginSelectBoxPosition
		$DragTest.sizeVector = get_global_mouse_position() - beginSelectBoxPosition
		$DragTest.update()

		# Do this like the dude said: keep a list of frogs that can be selected and check their x and y against
		# this dragged select box
		var myFrogs = QueryDesk.getMyCrew()
		QueryDesk.inputCaptain()._clear_selection()
		for i in range(myFrogs.size()):
			if (MathUtils.isVectorInARect(myFrogs[i].global_position, beginSelectBoxPosition, get_global_mouse_position())):
				var aTarget = Target.new()
				aTarget.node = myFrogs[i]
				QueryDesk.inputCaptain()._add_selection(aTarget)

	# user clicked to select something
	if (setActiveFocus):
		space_state = get_world_2d().direct_space_state
		# I updated this to WalledGarden code but it wasn't working anyway on frogs! Camel works
		var result = WalledGarden.intersect_point_AcrossGardens(setActiveFocus, 1, Array(), 2^1+2^2)
		if (result):
			var aTarget = Target.new()
			aTarget.vector = setActiveFocus # WRONG. This should be offset
			aTarget.offset = result[0].collider.to_local(setActiveFocus)
			aTarget.node = result[0].collider
			QueryDesk.inputCaptain()._clear_selection()
			QueryDesk.inputCaptain()._add_selection(aTarget)
		else:
			print("World._physics_process: No focus found"); 
		setActiveFocus = null

	# Well... this is crappy
	if (QueryDesk.inputCaptain().selectedObjects.size() and !is_dragging):
		$Camera2D.position = QueryDesk.inputCaptain().selectedObjects[0].node.global_position

func _draw():
	if (locationsToMark.size()):
		for i in range(locationsToMark.size()):
			print("Mark Location:", locationsToMark[i])
			
			# instantiate sprite with rollover functionality
			for e in locationsToMark[i].keys():
				addStaticPointOfInterest(locationsToMark[i][e], load("res://Sprites/dot.png"), e)
				
		locationsToMark = Array()

# add an image with some data in it that can be inspected
func addStaticPointOfInterest(aPosition, aTexture, textData, deletable=true):
	var aNode = StaticBody2D.new()
	
	aNode.set_collision_layer_bit(32, true)
	aNode.set_collision_mask_bit(32, false)
	aNode.set_collision_layer_bit(0, false)
	aNode.set_collision_mask_bit(0,false)

	add_child(aNode)
	aNode.global_position = aPosition
	
	var aSprite = Sprite.new()
	aNode.add_child(aSprite)
	aSprite.set_texture(load("res://Sprites/dot.png"))
	
	var aCollider = CollisionObject2D.new()
	aNode.add_child(aCollider)
	
	var anOwner_id = aNode.create_shape_owner(aNode)
	var aShape = RectangleShape2D.new()
	aShape.set_extents(Vector2(10,10))
	aNode.shape_owner_add_shape(anOwner_id, aShape)

# callback system for help function, rollovers and so on
# receive a rollover signal from object with link to itself, wait the delay for rollover help, then read the help
# information from the rollover object and drop it in a pretty bubble beside the object. The object should supply an origin
# point for the rollover message, and the message should point to it, but stay on the sreen.
# Also, once instantiated listen for the rollout message. 


# DEBUGGING TOOLS

# Receive a signal to trace an object's path.
# Highlight the object receiving commands currently (the left-clicked)
# Show the location of Right-Click and which object has been targeted.


# locations is a named array of locations to mark on screen
func _on_RigidMerchant_markLocations(locations):
	locationsToMark.append(locations)
	update()


func _on_markLocations(locations):
	locationsToMark.append(locations)
	update()
