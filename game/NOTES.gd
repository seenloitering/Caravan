"""
Alternate Game Title: Pray For It
Camel Gates: Walk, Amble, Pace, Gallop


### Here is a genius blast from the past
	Mounts are western elemental science and morale is eastern. So, the one is air, earth, water, fire and the other is earth, fire, water, wood, metal


### The Pitch ###
- Caravan is a multiplayer merchant race along the silk road during an alternate Dark Ages in which, rather than humans developing advanced intelligence, frogs did.
- The Caravan will not suffer as you all race to the next city and secure the best price for your goods unless a player prays for it. Someone always prays it. It would be prudent to make sure your prayers are answered before theirs are.
- Caravan is a multiplayer RTS side-scroller in which players, armed with religious zealotry, foretell the suffering and hardship that will plague everyone as they race along a dark ages silk road in a ship on the back of a giant camel that isn't actually giant because your crew is all frogs and, of course, frogs are just very small.
- Caravan is a game about the wind. It's drafting. It's about positioning.
- Caravan is a survival race on a mobile base.
	- Base -> Pray -> Suffer -> Win

- Image
	Frogs are praying to a frog christ on the deck of a giant dark ages camel saddle. They chant, "Rain horror on our enemies!"

- What do you want player's to feel?
- adventure
- cruelty

Frog: I must please God so I will prosper... and my enemies will suffer. 


- Racing, drafting, and crowding are PvP. Killing is PVE.
- a game about managing energy against the wind
- In this race... nothing is going to happen... unless you pray for it.

- Gif Storyboard
Draft
Crowd
Pray
Fight
Enjoy the scenary from the middle of the caravan 
Prepare
Suffer

# High-Risk Goods vs. Lowe-Risk Goods
- High-Risk goods result in huge gains and huge loses, whereas lower risk good guarentee a profit that is only very slightly effected by placement.
- This removes a guard against racers who aren't trying to win, but I don't think that battle is going to be won with incentives anyway.

# Add a "g" to create a gif of the last five seconds


# FRICTION - what keeps people from playing this game?
- What's this game's home? Comfortable things you can fall into.

#### Get it Out The Door ######
# Here are the basic pieces
2 - the mobile-base, RTS, Racing, side-scroller hybred
3 - the multiplayer component + Pay To Lose
4 - the AI
1 - the prophesy or portends mechanic
1 - the graphics, volume and so on.
- drafting and crowding

- I need to drop volume for quantity when it comes to graphics.


##### PAY TO LOSE #####
	This comes FOR SURE with a free release. Release the game for free open beta (eventually free to play early access on steam). 
	The opposite of PAY TO WIN, the PAY TO LOSE model sells disadvantages. The upside of disadvantages is vanity. Players who win while playing with disadvantages get their names in lights while unencumbered winners are forgotten to history. The more advantages you win with, the brighter the lights.

- a monitization model aimed at an eSport space. ESports exist entirely in an encumbered space. So in way, it's pay to compete at the highest level. Consider this a sort of special event ranked play.
- 



# Draw Fanatic Frogs
- FINALLY A STYLE
- the style consists of a black outline that is one shape with the blackest shadows. There is a border normal edge on flats that are not the shadow. The shadow is as if lit directly from overhead.
- The outline should have lots of knicks. It's dark ages rough. Not woodcutty, but those gesture are not unwelcome.
- HIGH CONRAST SHADING/low contrast colours



# Elements of Fanaticism
- air(Sanguine)<=>earth(Melancholic) : laughing and looking for agreement <=> obsessive and reasoning things out
- fire(Choleric)<=>water(Phlegmatic) : determined <=> dopey contentment
- ...and a balanced look

- think about the morale of a crew, what that is and how it works
- 


# Different religious states

- the calm guru
- angry determined and single-minded
- laughingly manic devotion
- outraged at the sinners
- smug
- 

# Players are juggling... what???
- guilding the mount through drafts and positioning in the caravan
- pulling off portends. So, suffering, praying, and sacrificing.
- Feeding and watering the crew and the animal.
- Fighting stuff that shows up and says boo.
- building and repairing the saddle
- scavaging stuff.
- negociating deals with other players.
- Outfitting and training crew?

# The game between races
- Conditioning mount.
- learning new portends.
- buying and selling junk.

# The Logic Behind Building #
	Being inside compartments is like being inside another dimension.

- The space to build inside a compartment is based on the precise area of its shape regardless of how strangly it's shaped. When building a compartment, its dimensions are showned (rounded off to ta useful metric from shipbuilding). 
- Things plced inside a compartment can be arranged however a player wants. The main consideration is how he'll access it. The game doesn't really care.
- Compartments are abstract. Doors, trapdoors and windows appear when being used. 
- Compartment walls are considered very very thin. If a players wants a thick wall, he needs to build a compartment and fill it with solid material.
- Structural integrity: weight is split between structures that touch the floor.
- compartments are always polygons.
- There is always a hypothetical floor in every compartment that crew will walk on. If it's not high enough to fit them, the top of their body just gets masked out.
- Compartments are basically storage containers that are bolted to the saddle.
- How do we indicate that crew are inside a structure? Maybe they become more abstract? Think about a special filter.
- Roofs are solid compartments with special qualities like:
	- shingled for snow, rain, and missle deflection.
	- parapets
- There's collapse and crushing. A compartment collapses when its footing wont support its weight. A compartment crushes when it cannot support the weight above it.
- There are 3 z depths on a saddle: the deck, the buildings on the deck, and the buildings below deck.
- Can below deck building obstruct above deck buildings? Theoretically, yes, but how do I represent that?
	- Below deck is always ONLY below deck and cannot be accessed from an above deck compartment. Crew must always pass onto the deck, then go through a trapdoor to get into the underdeck.
	- Underdeck cannot be built in front of eyelets.
- Can walls attach to neighboring floors and ceilings? Yes! because it's fun.
- When building a compartment, there is a minimum length for each edge and a minimum angle. The minimum angel for each point depends on how many degrees of the polygon have already been used up. So, if three points have been laid and the lone angle is 45 degrees, the two remaining angles must at least amount to to 2 times the minimum angle.

# The compartment building tool
- The things it has to do: pick a material, pick a type of compartment, draw the four corners of the compartment polygon to define its shape.
	- Use Case: Click on an existing edge and a polygon with the minimum height and width appears; moving the mouse slides the second point along the edge the first point was placed on (possibly extending it); then after a second point is placed, the third point will snap to a second edge if there was one, but can be pulled off of it (the snap distance is the minimum polygon angle seperating the first and second edge isn't more than twice as wide as the minimum angle, then the 3rd point MUST be paralell with the second edge); and then the forth point can be selected constrained by the minimum angle.
"""



