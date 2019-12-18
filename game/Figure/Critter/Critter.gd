extends KinematicBody2D

class_name Critter
# The Captain, The Hand, The Warrior, and The Priest OR Super Frog OR Fodder Frog

var MathUtils = load("res://Scripts/MathUtils.gd").new()
var LocalKinematicsUtils = load("res://Scripts/LocalKinematicsUtils.gd").new()

export var ownedBy: int = 0

const UP = Vector2.UP
const MAX_RANGE: float = 2000.0
const PLATFORM_AWARENESS: float = 30.0 # number of pixals at which creature will add himself to a lay to land on platforms
const HANGTIME: float = .8

signal markLocations

# Identity variables
export var is_canavanFriendly: bool = true # is this unit antagonistic to the caravan or friendly?

# variable for platform-like controls the _physics_process stuff
export (bool) var snap: bool = true
export (int) var move_speed: float = 350.0
export (int) var jump_speed: float = 1800.0 # Only for manual jump
export var slope_slide_threshold: float = 50.0 # This does nothing now
var velocity: Vector2 = Vector2() # Current velocity, altered by collision events!

var actions: Array = Array() # A stack of actions that need to be performed to complete the current plan (plans are stacked using shift-rClick)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

## Critter State Machine Definitions ## This class is the context ##
var orders:Array = Array()
var standingOrder 
var current_state
var interupting_state # maybe do interupts this way, assuming interupts will always clobber each other; once the interupt is finished, destroy self and return to current_state
var is_grounded:bool
var is_jumping:bool = false
var newGravity:float = 25
#################################


# PUBLIC
func get_class(): return "Critter"

func _ready()->void:
	QueryDesk.registerCreature(self, ownedBy)
	current_state = $States/Idle # The Starting state!

## State Machine Version ##
func _physics_process(delta)->void:
	
	is_grounded = _check_is_grounded()
	if is_grounded: # For debugging
		pass
	else:
		pass
	current_state.update(delta, self) # update the current state

func inputForward(event)->void:
	current_state.handle_input(event, self)

func changeState(newState)->void:
	current_state.exit()
	current_state = newState
	newState.enter()

func _check_is_grounded()->bool:
		# Raycasts looking for landing platforms
	# Check for ground first!
	var results = WalledGarden.getDefaultGardenState().intersect_ray(position, Vector2(position.x, position.y + 10), Array(), 2^3)
	if results:
		if results.collider != self.get_parent() && self.get_parent().get_class() == "BodyPart":
			var newLocalPos: Vector2 = results.collider.to_local(global_position)
			self.get_parent().remove_child(self)
			results.collider.add_child(self)
			self.position = newLocalPos
		return true
	
	# Check for other things in any other garden - ACK! This assumes we're already in the right WalledGarden
	results = WalledGarden.getCurrentState(self).intersect_ray(position, Vector2(position.x, position.y + 10), Array(), 2^3)
	print("Garden RID:", WalledGarden.getGarden(get_rid()).get_id())
	#WalledGarden.printWalledGardens()
	if results:
		if results.collider != self.get_parent() && results.collider.get_class() == "BodyPart":
			print("Garden RID before LocalKinematic move:", WalledGarden.getGarden(get_rid()).get_id())
			var newLocalPos: Vector2 = results.collider.to_local(global_position)
			self.get_parent().remove_child(self)
			results.collider.add_child(self)
			self.position = newLocalPos
			WalledGarden.moveToWalledGarden(self, results.collider.superStructure)
			print("Garden RID after LocalKinematic move:", WalledGarden.getGarden(get_rid()).get_id())
			print("My Parent is:", self.get_path())
		return true
	return false


func accomplishedOrder()->void:
	orders.pop_front()
###########################

func OLD_physics_process(delta):
	var totalDisplacement
	var a: Target
	var results
	# Rather than zero here, I want to take the velocity of what I'm standing on
	if (snap): # Don't zero velocity while airbourne
		velocity.x = 0
		results = WalledGarden.getCurrentState(self).intersect_ray(position, Vector2(position.x, position.y + 25), Array(), 2^3)
		if results:
			print("Floor velocity:", get_floor_velocity())
			print("Collider:", results.collider)
			#velocity = get_floor_velocity()
	# When jumping to a target (not falling) I want to add its velocity to my own -- good jumper!

	if velocity.y > 0 and get_world_2d().get_space() != Physics2DServer.body_get_space(get_rid()):
		# if falling and not already in the default WalledGarden
		# then raycast for ground in the World WalledGarden and switch back to it if you'll collide
		# get_world_2d() is always the default walledgarden
		results = WalledGarden.intersect_ray_AcrossGardens(position, Vector2(position.x, position.y + 25), Array(), 2^3)
		if results:
			print("SEND BACK TO DEFAULT WALLEDGARDEN!")
			WalledGarden.moveToWalledGarden(self,results.collider)
	
	velocity.y += gravity * delta
		
	if (actions.size() and snap and actions[0].types["MOVE"] == actions[0].type):
		a = actions[0]
		snap = false
		velocity = MathUtils.getTragectoryVector(global_position, a.vector, HANGTIME)
		print("VELOCITY:", velocity)
		WalledGarden.moveToWalledGarden(self,a.node)

	var snap_vector = Vector2(0,32) if snap else Vector2() # The snap vector should be the current normal?
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector2.UP, false)
	#velocity = move_and_slide(velocity, Vector2.UP, false, 4, 0.785398, false)
	
	var just_landed := is_on_floor() and not snap
	if just_landed:
		print("Landed on:", $tailCast2D.get_collider())
		print("tailCast2D's WalledGarden:", $tailCast2D.get_canvas().get_id(), " and Critter:", Physics2DServer.body_get_space(get_rid()).get_id())
		
		snap = true
		actions.pop_front() # this action is like dead


func _physics_process_old(delta):
	var theRoot
	var totalDisplacement
	var a: Target
	###### Cursor Keys Movement ####
	#var direction_x := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if (snap): # Don't zero velocity while airbourne
		velocity.x = 0
	else: # Only apply gravity in the air
		velocity.y += gravity * delta
		
	# If close enough to my target, add me to the platform collision layer.
	if actions.size() and !snap:
		a = actions[0]
		totalDisplacement = a.offset - position
		if totalDisplacement.length() < PLATFORM_AWARENESS and velocity.y >= 0.0 and get_collision_mask_bit(0) == false:
			set_collision_mask_bit(0,true)
		a.pending = false
	
	if (actions.size() and snap and actions[0].types["MOVE"] == actions[0].type):
		a = actions[0]
		# ALERT. Change this so that gravity constrains x - right now, you can jump down an unlimited distance
		totalDisplacement = a.vector - global_position
		if ((totalDisplacement.length() >= MAX_RANGE and totalDisplacement.y < 0) || totalDisplacement.length() < 25):
			if actions.size():
				actions.pop_front() # this action is like dead
			print("Out of range. (", totalDisplacement.length(), ")")
		else:
			# This guy is jumping, so we'll remove him from colliding with platforms until he's close to his target.
			print("REMOVE mask FOR layer 0")
			set_collision_mask_bit(0,false)
			# $CollisionShape2D.disabled = true <- removed from physics ENTIRELY!
			
			snap = false
			velocity = MathUtils.getTragectoryVector(global_position, a.vector, HANGTIME)
			# embark on the target object - check to see that we have a node at all
			# Instead of checking class, this should be a method that gets this platform's context: either a world or monster
			# A.embarkingObject() = the object I should embark on to do this action
			if a.node.get_class() == "Monster":
				if self.get_parent() != a.node:
					# Covert self global to monster local
					
					var newLocalPos: Vector2 = a.node.to_local(global_position)
					print("Parent me to a new Monster! called:", a.node, " instead of ", self.get_parent())
					QueryDesk.disembark(self, self.get_parent())
					self.get_parent().remove_child(self)
					a.node.add_child(self)
					self.position = newLocalPos
					# remove myself from our mutual collision exclusion lists
					QueryDesk.embark(self, a.node)
				print("I am now the proud child of:", self.get_parent())
			else:
				theRoot = get_tree().get_root().get_node("World")
				if self.get_parent() != theRoot:
					print("Send me back to the root")
					var newLocalPos: Vector2 = theRoot.to_local(global_position)
					# first, disembark from whereever I am
					QueryDesk.disembark(self, self.get_parent())
					self.get_parent().remove_child(self)
					theRoot.add_child(self)
					self.position = newLocalPos
			#emit_signal("markLocations", {"Jump": global_position, "Jump Target": actions[0].vector})
		a.pending = false

	var snap_vector = Vector2(0,32) if snap else Vector2() # What does this even do?
	velocity = move_and_slide_with_snap(velocity, snap_vector, UP, true, 4, 1,true)
	# move_and_slide_with_snap ( Vector2 linear_velocity, Vector2 snap, Vector2 floor_normal=Vector2( 0, 0 ), bool stop_on_slope=false, int max_slides=4, float floor_max_angle=0.785398, bool infinite_inertia=true )bool
	
	# The just_landed logic might not make sense considering the alteration to collision layers
	var just_landed := is_on_floor() and not snap # velocity.y <= 0
	if just_landed:
		snap = true
		print("JUST LANDED")
		# If I'm on the ground, move me there.
		var theCollision = get_slide_collision(0)
		if get_slide_collision(-1):
			if theCollision.get_collider() != actions[0].collider:
				if self.get_parent() != theRoot:
					print("Whoops! I didn't land on my target. Assume I'm on the ground")
					theRoot = get_tree().get_root().get_node("World")
					var newLocalPos: Vector2 = theRoot.to_local(global_position)
					# first, disembark from whereever I am
					QueryDesk.disembark(self, self.get_parent())
					self.get_parent().remove_child(self)
					theRoot.add_child(self)
					self.position = newLocalPos
		actions.pop_front() # this action is like dead

func select()->void:
	if $dot:
		$dot.visible = true

func deSelect()->void:
	if $dot:
		$dot.visible = false

func queueAction(anAction,typeOf="IMPLICIT")->void:
	# Figure out what to do from here.
	actions.append(anAction) # Old way
	orders.append(anAction) # New Way

func clearActions()->void:
	actions = Array() # should I be releasing all these obejcts? Maybe.

