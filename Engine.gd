extends StateMachine

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("cellSelected", self, "activateCell")
	GameEvents.connect("factoryActivated",self,"factoryActivated")	
	GameEvents.connect("foundOccupant", self, "foundOccupant")
	GameEvents.connect("validCombatTile", self, "validCombatTile")

func activateCell():
	state.activateCell()

func _input(event):
	if state.has_method("input"):
		state.input(event)
	
	
func foundOccupant(cell,occupant):
	if(state.has_method("foundOccupant")):
		state.foundOccupant(cell,occupant)

func validCombatTile(tile):
	if(state.has_method("validCombatTile")):
		state.validCombatTile(tile)
