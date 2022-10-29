extends TileMap

export(PackedScene) var tileScene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal tileCreated(instance,pos)
signal allTilesCreated()

# Called when the node enters the scene tree for the first time.

var highlightedCell = Vector2.ZERO
func _ready():
	$Cursor.init(cell_size)
	for pos in get_used_cells():
		var tileInstance = tileScene.instance()
		emit_signal("tileCreated",tileInstance,pos)
		set_cellv(pos,-1)
	emit_signal("allTilesCreated")
	GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell)
	

func _input(event):
	if event is InputEventMouseMotion:
		var mousePosition = world_to_map(get_global_mouse_position())
		if not mousePosition  == highlightedCell:
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,mousePosition)
	else:
		if Input.is_action_pressed("ui_left"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.LEFT)
		if Input.is_action_pressed("ui_right"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.RIGHT)
		if Input.is_action_pressed("ui_up"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.UP)
		if Input.is_action_pressed("ui_down"):
			GameEvents.emit_signal("highlightedNewCell",highlightedCell,highlightedCell + Vector2.DOWN)
		
		
		if Input.is_action_just_pressed("ui_accept"):
			GameEvents.emit_signal("cellSelected",highlightedCell)



func _on_TileManager_switchedTileHighlight(newTile):
	highlightedCell = newTile
