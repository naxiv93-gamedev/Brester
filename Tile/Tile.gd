extends Node2D

export(Resource) var runtimeData = runtimeData as RuntimeData

var stats : Resource
var structure : Structure = null
var pathfinding = Pathfinding.new(self)
var occupant
var cost = 1

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
			structure.activate(getPosition())
		else:
			print(name + " has been activated!")
func movement():
	if isInRange():
		if occupant:
			GameEvents.emit_signal("foundOccupant",self,occupant)
		else:
			GameEvents.emit_signal("suitableCell",self)
	else:
		GameEvents.emit_signal("cancelMovement")

			


func addStructure(structure):
	structure = load("res://Database/objects/Structures/Factory.tres")
	self.structure = structure
	var structureSprite = Sprite.new()
	structureSprite.name = "StructureSprite"
	structureSprite.texture = structure.structureTexture
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
			neighborEnemies.append(neighbor)
	return neighborEnemies

func hasNeighborEnemies():
	return getNeighborEnemies().size() != 0
func hasCapturableBase():
	return structure

