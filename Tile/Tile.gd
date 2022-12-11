extends Node2D

export(Resource) var runtimeData = runtimeData as RuntimeData

var stats : Resource
var structure : Structure = null
var pathfinding = Pathfinding.new(self)
var occupant
var cost = 1
var mapPos
var isOccupantFromActivePlayer = false
var isStructureFromActivePlayer = false
func init(tile):
		var size = $Sprite.texture.get_size()
		self.position = (tile * size) + (size/2)
		var vectorString = var2str(tile)
		name = vectorString.replace("Vector2","Tile")
		pathfinding.connect("inRange",self,"inRange")
		pathfinding.connect("noRange", self,"noRange")

func _ready():
	pass

func getPosition():
	return str2var(name.replace("Tile","Vector2"))

func addNeighbors(tileDict):
	var tile = getPosition()
	
	var coords = [
			tile + Vector2.UP,
			tile + Vector2.DOWN,
			tile + Vector2.LEFT,
			tile + Vector2.RIGHT
	]
	
	for coord in coords:
		if(tileDict.has(coord)):
				var neighbor = tileDict[coord]
				pathfinding.neighbors.append(neighbor)

func select(oldTile):
	if $RangeSprite.visible:
		GameEvents.emit_signal("drawPath",pathfinding.getCustomList(self))

func unselect(newTile):
	if $RangeSprite.visible:
		pathfinding.goingTo = newTile

func idle():
		if occupant:
			GameEvents.emit_signal("foundOccupant",self,occupant)
		elif structure:
			GameEvents.emit_signal("isStructureFromActivePlayer",self)
			if isStructureFromActivePlayer and structure.canBeActivated:
				GameEvents.emit_signal("structureActivated",self)
				isStructureFromActivePlayer = false
			else:
				GameEvents.emit_signal("popUpIdleMenu",self)
		else:
			GameEvents.emit_signal("popUpIdleMenu",self)
func movement():
	if isInRange():
		if occupant:
			GameEvents.emit_signal("foundOccupant",self,occupant)
		else:
			GameEvents.emit_signal("suitableCell",self)
	else:
		GameEvents.emit_signal("cancelMovement")

func combat():
	if isInRange():
		GameEvents.emit_signal("validCombatTile", self)
		
func addStructure(structure):
	self.structure = structure
	var structureSprite = structure.sprite
	structureSprite.name = "StructureSprite"
	add_child(structureSprite)

func addUnit(unit):
	self.occupant = unit

func isInRange():
	return $RangeSprite.visible
func inRange():
	$RangeSprite.visible = true

func noRange():
	$RangeSprite.visible = false

func getNeighborEnemies():
	var neighborEnemies = []
	for neighbor in pathfinding.neighbors:
		if neighbor.occupant:
			GameEvents.emit_signal("isOccupantFromActivePlayer",neighbor,neighbor.occupant)
			if(!neighbor.isOccupantFromActivePlayer):
				neighborEnemies.append(neighbor)
			neighbor.isOccupantFromActivePlayer = false
	return neighborEnemies

func hasNeighborEnemies():
	return getNeighborEnemies().size() != 0
func hasCapturableBase():
	if structure:
		GameEvents.emit_signal("isStructureFromActivePlayer",self)
		return !isStructureFromActivePlayer
	else:
		return false
func switchStructureColors(colorsArray):
	for i in colorsArray.size():
		$StructureSprite.material.set_shader_param("color" + str(i),Color(colorsArray[i]))
