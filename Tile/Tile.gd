extends Node2D


var stats : Resource
var structure : Resource = null
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
		print("G List: " + str(pathfinding.getGList(self).getList()))
		print("Custom List: " + str(pathfinding.getCustomList(self).getList()))
		GameEvents.emit_signal("drawPath",pathfinding.getCustomList(self))
		#GameEvents.emit_signal("drawPath",pathfinding.getGList(self))

func unselect(newTile):
	if $RangeSprite.visible:
		pathfinding.goingTo = newTile

func activate():
	
	#Here a signal will be emitted depending on the conditions and the tile 
	
	if structure != null:
		structure.activate(getPosition())
	elif occupant != null:
		print(name + "'s occupant has been activated!")
		GameEvents.emit_signal("clearGData")
		pathfinding.startG(occupant.stats.movement_range,1)
		print("G List: " + str(pathfinding.getGList(self)))
		print("Custom List: " + str(pathfinding.getCustomList(self).getList()))
		GameEvents.emit_signal("drawPath",pathfinding.getCustomList(self))
		#GameEvents.emit_signal("drawPath",pathfinding.getGList(self))
	else:
		print(name + " has been activated!")
		

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
