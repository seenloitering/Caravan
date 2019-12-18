"""
#### ToDo

# SHADER AND ART ASSETS
	# THE SHADER PROCESS and what I'm drawing
		The shader will set width of saturation based on atmospheric perspective but for the moment, let's talk in terms of the foreground. All art assets are black and white. When color is applied to the graphic it's applied with a saturation maximum and a curve. The maximum represents the height of the curve, and the curve itself represents a sort of bell curve where values approaching middle grey get more saturation and values approaching black or white get less.
		There is then a second saturation pass that sets atmospheric perspective for distant layers, but also the values of the whitest whites and blackest blacks in the foreground.
		As an aside, consider allowing two background colors where depending on the value of grey, the fill drifts toward one value or the other. Also consider being about to imput three colors: an overall color that gets mixed with two colors that are assigned to specific grey values as per the previous sentence.
	# WITH THAT IN MIND
		Really, any black and white drawing will do, but I can assign specific tones where color will move from shadow lighting to direct lighting.
		If I want areas to be colored differently, they should be seperate drawings (aka. seperate PNGs).
	# The PLAN
		Given:
			- atmospheric saturation and hue
			- an instance defined color, saturation min/max (compression), and value min/max (compression)
			- a PNG where saturation 0 is to be replaced by the instance defined color, containing all value information
			- and a curve that determines what range of values should be saturated
			- manager objects instances inherit attributes from
			- and where colors with saturation above 0 are not replced by the instance defined

- Really Overhaul the targetting action system
- Also, left-clicking changes focus, but right-clicking will ALWAYS direct the currently selected frogs. So, selecting a camel doesn't unselect the frogs.
	- listeningCrew and focus object are different things (dragging in space unselects all crew)
- !Pathfinding!
- Change of targeting logic. Oh boy. To facilitate walking on walls and all that, player-selected targets should be found by launching rays in all directions and returns the nearest surface. Basically, "go to the edge closest to right-click."
- Animation Tool. Make a tool for bones that will select objects outside of the bones to edit along with it. You can specify multiple targets nad tracks for each target.
	- this tool must guarentee that the target objects have the same origin as the bone.
	
#### In Progress ##########

- Changing Walled Gardens for Critters and THEN LocalKinematics
	- _check_is_grounded needs to create rays rather than using preplaced ones that need to be Wallgardened. Does it?
	- currently, _check_is_grounded is strangely adding and removing critters to a series of colliders that come from god knows where.
	suspecting the parent it's being added to keeps getting a new ID
	
# WalledGarden, LocalKinetics (standing on an object means becoming a child of it), collision, action, and view depth systems.
	OKAY Here's the crazy. 
	The WalledGarden system simulates a sort of cheap isolation of collision z-depth. 
	The LocalKinetics system simulates the transfer of kinetic energy from large objects to small (in this case, from Beast to the Critters riding them). In practical terms, the critters become children of CollisionShape2Ds and inherit their transforms. 
	The Action system manages what a Critter is doing modularly.
	The view depth system effectively seperates how things appear from the other systems, BUT WILL effect things like user selection (things in front get selected first). 
	- Platforms can be Static2Ds again
	- Think about the jiggering of Critters navigating a mount composed of multiple WalledGardens. Specifically ships, decks, and buildings.
	- Implement LocalKinematics. (RemoteTransform2D can't fo it... so back to childing riders)
	
# Movement in the WalledGarden paradigm #
- The nice thing about moving critters into a platform's hierarchy as well as it's walled garden is that there are no more moving platforms because the critter moves along... EXCEPT FOR ANIMATIONS.
- So, either critters get added to the heirarchy of whatever they're standing on, or I still have to deal with platforms moving because of animation.
- I like adding them to the geometry PLUS interpolating movement when there's a jump PLUS code that determines when a thing gets thrown off some platform and so returns to the world hierarchy.
- RELATED PROBLEM: WalledGardens do not bring their children with them. 
	- children could listen to signals from their parent and move with them when the signal is sounded. Think this through...
 		- the idea here is that an object is following the movements of some other object such that they will switch walled gardens together.

Buildings and Mounts are in their own WalledGardens
WalledGardened objects have an area2D collision space that return objects to the world if they exist them.
	- What about objects on the floor? A SOLUTION: every WalledGarden has a Y plane beneath which a figure is returned to its WalledGarden's parent WalledGarden. Also, WalledGardens have a hierarchy.
	- Since WalledGardens need parents and so on, should they use the scene tree? ONLY is animation platforms are not accomidated by moving Critters into them.

THING TO KEEP IN MIND WHEN MOVING CRITTERS
- delay moving the critter to the new WalledGarden until its feet actually leave the ground. The windup animation needs to play first.

CAPTAIN CENTERED
- Walled Gardens are indexed by captain. Which walled garden a specific object belongs in depends on who owns it, unless
it's a critter who jumps gardens.
- WalledGardens have a ground under which any object will be kicked out into the world. OR they have an active area out of
which a critter will be returned to normal space. OR every garden has a copy of the ground in it.
- think about onewayness

# Thinking Through Saddle Collision - just called platforms from here on out.
- the saddle, ship, and mount overlap but sections of the ship do it. It does together like a jizsaw, however, there will being interactable objects that overlap, but they only matter for event handling and finding the point in the ship where they're mounted.
- the sADDLE IS always in front of the mount, and the ship is always in front of the saddle. 
- Sections of the ship *could* be area2Ds and ONLY the outside boundary is a staticBody2D (this will help limit the number of static2Ds and by extension, collisions)
- I can condense this further by making the saddle the surface that surrounded the saddle and the ship (even though they capture events as different objects). 
############

- Extend platform logic to levels within a mount (and generally rethink)
	- RMB targetting needs better logic. Here are some examples.
		- find the nearest landable surface along all four ordinals
		- click-above logic means that even if a body is clicked on, the surface below is the actual target provided the two objects actually overlap.
		- RMB drag gesture. Search for a surface in the direction of a swipe.
		- targetting is more abstract than precise. Targeting an animal's back really means land somewhere on deck.
		- if nowhere, find the nearest ordinal; if a body, prefer a surface below but if there isn't one, use the surface above.
		- frogs are given specific comands via objects built on ship (ie. selecting the telescope station, arms the frog with the telescope and sends him around the ship keeping watch)
	- boarding may get terribly complex in order to adjust for animating surfaces. Solutions may include....
		- boarding always happens at the compartment level and every animated collider on a platform is considered its own compartment.
		- can I put StaticBody2Ds inside of skeleton bones?
		- consider getting rid of physics entirely at this point and doing my own collision with staticBodies
		- maybe just move jumpers using move_and_collide.
		- the saddle is really a single animated object with multiple collision shapes and containers.

- BUG: its not finding the saddle static body. Do an isolated test to make sure you can put staticbodies inside staticbodies.
- BUG: because I can queue up actions forever, by the time I get around to finding a node target, the node has moved.
	- _physics_process on Captain need to find nodes for all the queued actions.... or something depending on final targeting system.
- BUG: If platforms are overlapping, right-clicking selects the rearmost instead of the front.
- BUG: frogs should typically stick to everything, so the only time they should slide_and_snap while airbourne is when they're falling or out of control.

#### Back-Burner
-# COLLISION LOGIC FOR FROGS. What if, when creatures jump they are removed completely from the layer 
	where they collide with platforms and then, not added again until they have a y+ tragectory and are within a certain number
	of pixals of their target -- risky because it depends on how fast the game is running. OR a point where they'll have a
	clear path is found and when they pass that point, they're layer is turned on again. ALSO this may be a replacement for
	the whole one-way thing, which would be good because frogs can land on any surface to be honest.

	1) jumpers have their platform mask removed until they are moving downwardly and are within range. KINDA WORKED because:
		a) move_and_slide: I think move_and_slide is causing teleporting when creature's platform mask is turned on
			- this seems to have gone away.
		b) unpredictable delta of distance to target checks is causing misses. I could alter the check distance based on
			delta but this will still fail on a check that's suddenly long. Consider better logic. Using delta since junp and hangtime is figure how lose to end is probably best
			- this may be a problem later but for now it's holding
		Try Alternatives:
			1) CLEANEST. colliders.disabled=true
				- for now, use delta since launch to calculate where along the desires tragectory we should be, along with
				typical move_and_collide until the time is nigh, then move our to the target loc and return to normal.
				- maybe set location before turning the collider back on
			2) there's an area2d, oriented according to the target edge's normal, that triggers and turns the platform mask on when a specific kinematic2D enters.
			3) there's a clear raycast to the target.
			4) turn mask on test_move, then turn it off again unless it's reaching its target
			5) Some combination of these.


#### DONE

-#Boardable Platforms: boardable plateforms is QueryDesk's system for embarking and disembarking creatures from platforms using exceptions. 
Finding best platform target given a location: implimented across Captain and Creature


"""