extends State

signal requestUnit(combat)

var unit = null
var enemies  = null

func newState():
	emit_signal("requestUnit",self)
	enemies = unit.list.getEnd().getNeighborEnemies()

func findTile(vector2):
	for tile in enemies:
		var direction = Vector2(sign(tile.position.x - unit.position.x),sign(tile.position.y - unit.position.y))
		if vector2 == direction:
			return tile

func input(event):
	if Input.is_action_just_pressed("ui_accept"):
		GameEvents.emit_signal("cellSelected")
	else:
		GameEvents.emit_signal("moveCursor",event)
