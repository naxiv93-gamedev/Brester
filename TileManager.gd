extends Node

var tileDict ={}

signal switchedTileHighlight(newTile)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	GameEvents.connect("highlightedNewCell",self,"switchSelectedTile")
# warning-ignore:return_value_discarded
	GameEvents.connect("cellSelected", self, "activateCell")
# warning-ignore:return_value_discarded
	GameEvents.connect("structureActivated",self,"structureCalledTest")
# warning-ignore:return_value_discarded
	GameEvents.connect("unitSpawned",self,"unitSpawned")
	
	
func switchSelectedTile(oldTile,newTile):
	if tileDict.has(oldTile) and tileDict.has(newTile):
		tileDict[oldTile].unselect(tileDict[newTile])
		tileDict[newTile].select(tileDict[oldTile])
		emit_signal("switchedTileHighlight",newTile)

func _on_TileMap_tileCreated(instance, pos):
	add_child(instance)
	instance.init(pos)
	tileDict[pos] = instance 

func _on_TileMap_allTilesCreated():
	var threads = []
	for tile in get_children():
		var neighborThread = Thread.new()
		neighborThread.start(tile,"addNeighbors",tileDict)
		threads.append(neighborThread)
	for thread in threads:
		thread.wait_to_finish()

func activateCell(selectedCell):
	tileDict[selectedCell].activate()

func _on_StructureMap_structureFound(pos,structure):
	tileDict[pos].addStructure(structure)

func structureCalledTest(pos):
	var testName = tileDict[pos].name
	print(testName + "'s structure has been activated!")

func unitSpawned(pos,unit):
	tileDict[pos].occupant = unit
