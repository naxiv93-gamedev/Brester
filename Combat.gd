extends State

signal requestUnit(combat)
signal resetMovement()
var unit = null
var cell = null
var enemies  = null
var inMenu = false
func _ready():
	GameEvents.connect("selectedSwitchCombat",self,"selectedSwitchCombat")
	GameEvents.connect("selectedCancelCombat",self,"selectedCancelCombat")
	GameEvents.connect("selectedAttackCombat",self,"selectedAttackCombat")
func newState():
	emit_signal("requestUnit",self)
	cell = unit.list.getEnd()
	enemies = cell.getNeighborEnemies()
	for enemy in enemies:
		enemy.inRange()
	

func findTile(vector2):
	for tile in enemies:
		var direction = Vector2(sign(tile.position.x - unit.position.x),sign(tile.position.y - unit.position.y))
		if vector2 == direction:
			return tile

func input(event):
	if !inMenu:
		if Input.is_action_just_pressed("ui_accept"):

			GameEvents.emit_signal("cellSelected")
		else:
			GameEvents.emit_signal("moveCursor",event)
	else:
		pass
func activateCell():
	GameEvents.emit_signal("cellStateSelected","combat")

func getNearestTile(globalMousePosition):
	var lowestPositionTile = null
	for tile in enemies:
		if lowestPositionTile:
			var distanceToTile = tile.position - globalMousePosition
			var distanceToLowestPositionTile = lowestPositionTile.position - globalMousePosition
			if distanceToTile <= distanceToLowestPositionTile:
				lowestPositionTile = tile
		else:
			lowestPositionTile = tile
			
	return lowestPositionTile

func validCombatTile(tile):
	inMenu = true
	GameEvents.emit_signal("combatMenu")

func selectedCancelCombat():
	inMenu = false
	emit_signal("resetMovement")
func selectedSwitchCombat():
	inMenu = false 
func selectedAttack():
	inMenu = false
