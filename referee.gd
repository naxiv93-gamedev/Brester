extends Node


var winner = null
var unitsP1 = []
var unitsP2 = []
var structuresP1 = []
var structuresP2 = []

var player1Palette = ["#000000","#692d3a","#ad2139","#bd4d4d","#000000","#000000","#000000","#000000","#ffffff"]
var player2Palette = ["#000000","#15153e","#1a4374","#1e757e","#000000","#000000","#000000","#000000","#ffffff"]
var neutralPalette = ["#000000","#222222","#444444","#666666","#000000","#000000","#000000","#000000","#ffffff"]
# Each player will have his units array, structures array and money.
var player1 = {
	'name' : "player1",
	'units': unitsP1,
	'structures': structuresP1,
	'money': 0,
	'hq': null,
	'palette': player1Palette
}
var player2 = {
	'name' : "player2",
	'units': unitsP2,
	'structures': structuresP2,
	'money': 0,
	'hq': null,
	'palette': player2Palette
}
var queue = [player1,player2]

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("unitSpawned",self,"unitSpawned")
	GameEvents.connect('selectedEndTurnIdle',self,'onUnitPetition')
	GameEvents.connect('isOccupantFromActivePlayer',self,'onCheckUnit')
	GameEvents.connect('isStructureFromActivePlayer',self,'isStructureFromActivePlayer')
	GameEvents.connect("structureFound", self, "structureFound")
	GameEvents.connect("captureStructure",self, "captureStructure")
	GameEvents.connect("unitDied",self,"unitDied")


func onCheckUnit(idle,occupant):
	var activePlayer = queue[0]
	for unit in activePlayer['units']:
		if unit == occupant:
			idle.isOccupantFromActivePlayer = true
func isStructureFromActivePlayer(tile):
	var activePlayer = queue[0]
	for structure in activePlayer['structures']:
		if structure == tile.structure:
			tile.isStructureFromActivePlayer = true
func onSelectedEndTurnIdle():
	var next = queue.pop_front()
	checkWinner()
	for i in next['units']:
		i.getRecovered()
	var structures = next['structures'].size()
	if structures > 0:
		next['money'] += 1000*structures

	queue.push_back(next)
	GameEvents.emit_signal("beginPlayerTurn",queue[0])
	

#func _process(delta):
func checkWinner():
	if player1['units'].empty() or !player1['hq']:
		winner = player2
	#	GameEvents.emit_signal("tellTheWinner",self,'p1')
	if  player2['units'].empty() or !player2['hq']:
	#	GameEvents.emit_signal("tellTheWinner",self,'p2')
		winner = player1
func unitSpawned(pos,unit,player):
	match player:
		"player1":
			#do some bullshit
			unit.init(pos,player1Palette)
			player1['units'].append(unit)
		"player2":
			#do some more bullshit
			unit.init(pos,player2Palette)
			unit.faceLeft()
			player2['units'].append(unit)

func structureFound(pos,structure,player):
	structure = structure.duplicate()
	match player:
		"Player1":
			structure.init(player1Palette)
			if structure.structureName == "HQ":
				player1['hq'] = structure
			player1['structures'].append(structure)
		"Player2":
			structure.init(player2Palette)
			if structure.structureName == "HQ":
				player2['hq'] = structure
			player2['structures'].append(structure)
		"Neutral":
			structure.init(neutralPalette)
	GameEvents.emit_signal("sendStructure",pos,structure,player)

func captureStructure(tile):
	var activePlayer = queue[0]
	for player in queue:
		player['structures'].erase(tile.structure)
		if player['hq'] == tile.structure:
			player['hq'] = null
	activePlayer['structures'].append(tile.structure)
	tile.switchStructureColors(activePlayer['palette'])
	
func unitDied(unit):
	if player1['units'].has(unit):
		player1['units'].erase(unit)
	elif player2['units'].has(unit):
		player2['units'].erase(unit)
