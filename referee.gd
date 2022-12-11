extends Node

export(PackedScene) var unitScene
export (Resource) var tankStats
export (Resource) var copterStats
export (Resource) var antiairStats
export (Resource) var infantryStats
signal sendUnit(pos,unit)
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
	'number' : "player1",
	'units': unitsP1,
	'structures': structuresP1,
	'money': 100000,
	'hq': null,
	'palette': player1Palette
}
var player2 = {
	'name' : "player2",
	'number' : "player2",
	'units': unitsP2,
	'structures': structuresP2,
	'money': 1000000,
	'hq': null,
	'palette': player2Palette
}
var queue = [player1,player2]

var tileSelectedStructure
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("askPlayerName",self,"givePlayerName")
	GameEvents.connect("askPlayerIncome",self,"givePlayerIncome")
	GameEvents.connect("unitSpawned",self,"unitSpawned")
	GameEvents.connect('selectedEndTurnIdle',self,'endTurn')
	GameEvents.connect('isOccupantFromActivePlayer',self,'onCheckUnit')
	GameEvents.connect('isStructureFromActivePlayer',self,'isStructureFromActivePlayer')
	GameEvents.connect("structureFound", self, "structureFound")
	GameEvents.connect("captureStructure",self, "captureStructure")
	GameEvents.connect("unitDied",self,"unitDied")
	GameEvents.connect("beginTurn",self,"beginTurn")
	GameEvents.connect("selectedInfantry",self,"selectedInfantry")
	GameEvents.connect("selectedTank",self,"selectedTank")
	GameEvents.connect("selectedAntiair",self,"selectedAntiair")
	GameEvents.connect("selectedBcopter",self,"selectedBcopter")
	GameEvents.connect("structureActivated",self,"structureActivated")
	GameEvents.connect("askPlayerMoney",self,"givePlayerMoney")
	GameEvents.emit_signal("requestPlayerNames", self,"givePlayerMoney")

func givePlayerName(beginTurn):
	print("1")
	var activePlayer = queue[0]
	beginTurn.player = activePlayer['name']

func givePlayerIncome(beginTurn):
	var income = 0
	var player = null
	if player1['name'] == beginTurn.player:
		player = player1
	elif player2['name'] == beginTurn.player:
		player = player2
	income = calculateIncome(player)
	player['money'] += income
	beginTurn.income = income
	GameEvents.emit_signal("editPlayerUI",player)
func beginTurn():
	GameEvents.emit_signal("beginPlayerTurn",queue[0])
func calculateIncome(player):
	var income = 0
	for structure in player['structures']:
		income += 1000
	return income

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
func endTurn():
	var next = queue.pop_front()
	for i in next['units']:
		i.getRecovered()
	queue.push_back(next)

func structureActivated(tile):
	tileSelectedStructure = tile
#func _process(delta):
func checkWinner():
	for player in queue:
		if player['units'].empty() or !player['hq']:
			print(player['units'].empty())
			print(!player['hq'])
			queue.erase(player)
			winner = queue[0]
			GameEvents.emit_signal("foundWinner",winner['name'])

func unitSpawned(pos,tileName):
	tileName = tileName as String
	var player = tileName.split("-")[0]
	var unitType = tileName.split("-")[1]
	var playerPalette
	var unitInstance = unitScene.instance()
	match player:
		"p1":
			playerPalette = player1Palette
			player1['units'].append(unitInstance)
		"p2":
			#do some more bullshit
			playerPalette = player2Palette
			unitInstance.faceLeft()
			player2['units'].append(unitInstance)
	match unitType:
		"Infantry":
			unitInstance.stats = infantryStats
		"Tank":
			unitInstance.stats = tankStats
		"Antiair":
			unitInstance.stats = antiairStats
		"Bcopter":
			unitInstance.stats = copterStats
	unitInstance.stats = unitInstance.stats.duplicate()
	unitInstance.init(pos,playerPalette)
	add_child(unitInstance)
	emit_signal("sendUnit",pos,unitInstance)
	
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
	checkWinner()
	
func unitDied(unit):
	print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
	for player in queue:
		if player['units'].has(unit):
			player['units'].erase(unit)
	checkWinner()
func selectedInfantry():
	spawnUnit(infantryStats)
	queue[0]['money'] -= 1000
func selectedTank():
	print("tmep")
	spawnUnit(tankStats)
	queue[0]['money'] -= 6000
func selectedBcopter():
	spawnUnit(copterStats)
	queue[0]['money'] -= 7000
func selectedAntiair():
	spawnUnit(antiairStats)
	queue[0]['money'] -= 8000
func spawnUnit(stats):
	var unitInstance = unitScene.instance()
	unitInstance.stats =  stats.duplicate()
	var activePlayer = queue[0]
	activePlayer['units'].append(unitInstance)
	unitInstance.init(tileSelectedStructure.getPosition(),activePlayer['palette'])
	add_child(unitInstance)
	emit_signal("sendUnit",tileSelectedStructure.getPosition(),unitInstance)
	GameEvents.emit_signal("unitMenuDespawns")
	unitInstance.getTired()
func givePlayerMoney(menu):
	menu.money = queue[0]['money']

