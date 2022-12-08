extends Node

class_name StateMachine

var state = null #Holds active state
var nextState = state 
var stateNew = true

var stateMap = {}


onready var states = $States.get_children()


#Initializes the state machine and prepares everything to run properly
func init():
	if states.size() != 0:
		state = states[0]
		nextState = state
		stateNew = true
	
	for arrayState in states:
		arrayState.connect("switchState",self,"stateSwitch")
		stateMap[arrayState.name] = arrayState

#Executes the state given and if it isn't there it switches to a default state
func execute(delta):
	if states.has(state):
		#If the state is new, execute the state's newState function for the state's basic setup
		if stateNew:
			state.newState()
		state.execute(delta)
	else:
		stateSwitch(states[0].name)

#prepares stateNew values for the next step and switches states if necessary 
func update():
	if nextState != state:
		state = nextState
		stateNew = true
	else:
		if stateNew:
			stateNew = false


 #used when a state switch is needed
func stateSwitch(name):
	if stateMap.has(name):
		nextState = stateMap.get(name)
	else:
		print("Tried to switch to a non-existing state. Switching to first state...")
		nextState = stateMap.get(stateMap.keys()[0])



func _ready():
	init()

func _process(delta):
	execute(delta)
	update()
