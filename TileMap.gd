extends TileMap

export(PackedScene) var tileScene
export(Resource) var runtimeData = runtimeData as RuntimeData
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tileDict ={}

var combatOriginTile = null
signal tileCreated(instance,pos)
signal allTilesCreated()
signal switchedTileHighlight(newTile)

# Called when the node enters the scene tree for the first time.

var highlightedCell = Vector2.ZERO
func _ready():
	GameEvents.connect("moveCursor",self,"cursorMovement")
	# warning-ignore:return_value_discarded
	GameEvents.connect("highlightedNewCell",self,"switchSelectedTile")
# warning-ignore:return_value_discarded
	GameEvents.connect("cellStateSelected", self, "activateCell")
# warning-ignore:return_value_discarded
	GameEvents.connect("structureActivated",self,"structureCalledTest")
# warning-ignore:return_value_discarded
	GameEvents.connect("unitSpawned",self,"unitSpawned")

	$Cursor.init(cell_size)
	for pos in get_used_cells():
		var tileInstance = tileScene.instance()		
		emit_signal("tileCreated",tileInstance,pos)
		set_cellv(pos,-1)
	emit_signal("allTilesCreated")
	GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell)






func cursorMovement(event):
	if event is InputEventMouseMotion:

		var mousePosition = world_to_map(get_global_mouse_position())
		if not mousePosition  == highlightedCell:
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,mousePosition)
	else:

		if Input.is_action_pressed("ui_left"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.LEFT)
		elif Input.is_action_pressed("ui_right"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.RIGHT)
		elif Input.is_action_pressed("ui_up"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.UP)
		elif Input.is_action_pressed("ui_down"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.DOWN)

func cursorMovementCombat(combat):
	pass
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

func activateCell(script):

	tileDict[highlightedCell].call(script)

func _on_StructureMap_structureFound(pos,structure):
	tileDict[pos].addStructure(structure)

func structureCalledTest(pos):
	var testName = tileDict[pos].name
	print(testName + "'s structure has been activated!")

func unitSpawned(pos,unit):
	tileDict[pos].occupant = unit





func _on_TileMap_switchedTileHighlight(newTile):
	highlightedCell = newTile
	$Cursor.switchTileHighlight(newTile)
