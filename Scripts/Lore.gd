var pages = [
	LorePage.new(4, """There's something in the night.
	
	I'm stranded here in a forest with no daylight. I was fortunate enough
	to have my flashlight on me, but I'm worried about using up the battery,
	so I've been crafting torches from the sticks that pervade the forest floor.
	
	Still, I can't keep sitting in one place. The materials around me are
	plentiful, but they're not limitless. I need to assess my surroundings
	if I have any hope of getting back home. Plus, I want to write down
	anything that happens to me while I'm here.
	
	I'm going into the woods."""),
	LorePage.new(15, """The extra mobility portable light has given me has proved
	invaluable. I've noticed the odd stone here and there on the ground. Being
	the handy man that I am, I managed to scrape together an axe. Good timing,
	too. I was getting tired of picking up sticks.
	
	On a different note, these torches make for good breadcrumbs. I've been using
	them to mark where I've been in case I need to retrace my steps. Which happens
	often. All the forest looks the same. I wonder if I'll ever find anything.""",
	[preload("res://Scenes/Items/ItemAxe.tscn")]),
	LorePage.new(50, """I've found something.
	
	A cave, directly north of where I first arrived here. I've decided to move
	my primitive camp there for the time being. At least it's easier to find.
	If you're three feet away. Man, it is so dark.
	
	Anyway, a semi-permanent shelter is better than nothing, so I'll take what
	I can get. There's still so much forest to explore.
	
	(CAVE NOT IMPLEMENTED BUT YOU CAN GO LOOKING FOR WHERE IT WOULD HAVE BEEN)""")
]

class LorePage:
	var distance
	var text
	var recipe
	func _init(_distance, _text, _recipe = []):
		distance = _distance
		recipe = _recipe
		
		text = ""
		for i in _text.split("\n"):
			i = i.strip_edges()
			if i.empty():
				text += "\n\n"
			else:
				text += i + " "
