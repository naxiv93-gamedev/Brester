extends Node

var winner = null
var unitsP1 = []
var unitsP2 = []
var structuresP1 = []
var structuresP2 = []
# Each player will have his units array, structures array and money.
var player1 = {'units': unitsP1,'structures': structuresP1,'money': 0}
var player2 = {'units': unitsP2,'structures': structuresP2,'money': 0}
var queue = [player1,player2]

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("unitSpawned",self,"unitSpawned")
	GameEvents.connect('selectedEndTurnIdle',self,'onUnitPetition')
	GameEvents.connect('isOccupantFromActivePlayer',self,'onCheckUnit')


func onCheckUnit(idle,occupant):
	var activePlayer = queue[0]
	for unit in activePlayer['units']:
		if unit == occupant:
			idle.isOccupantFromActivePlayer = true

func onSelectedEndTurnIdle():
	var next = queue.pop_front()
	checkWinner()
	for i in next['units']:
		i.getRecovered()
	queue.push_back(next)
	

#func _process(delta):
func checkWinner():
	if unitsP1.empty() == true:
		winner = player2
	#	GameEvents.emit_signal("tellTheWinner",self,'p1')
	if unitsP2.empty() == true:
	#	GameEvents.emit_signal("tellTheWinner",self,'p2')
		winner = player1
func unitSpawned(pos,unit,player):
	match player:
		"player1":
			#do some bullshit
			unit.init(pos,["#000000","#692d3a","#ad2139","#bd4d4d","#000000","#000000","#000000","#000000","#000000"])
			player1['units'].append(unit)
		"player2":
			#do some more bullshit
			unit.init(pos,["#000000","#15153e","#1a4374","#1e757e","#000000","#000000","#000000","#000000","#000000"])
			unit.faceLeft()
			player2['units'].append(unit)
