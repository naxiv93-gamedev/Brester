extends StateMachine

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("cellSelected", self, "activateCell")
	
	GameEvents.connect("foundOccupant", self, "foundOccupant")
	

	
func activateCell():

	state.activateCell()

func _input(event):
	if state.has_method("input"):
		state.input(event)
	
	
func foundOccupant(cell,occupant):
	if(state.has_method("foundOccupant")):
		state.foundOccupant(cell,occupant)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

