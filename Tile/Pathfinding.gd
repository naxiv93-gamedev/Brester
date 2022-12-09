class_name Pathfinding

var neighbors = []
var G = -1
var tile 
var parent
signal inRange()
signal noRange()
var goingTo = null
var comingFrom = null


func _init(tile):
	self.tile = tile
	GameEvents.connect("clearGData", self, "clearG")

func startG(unitRange, unitMoveType):
	G = 0
	emit_signal("inRange")
	for neighbor in neighbors:
		neighbor.pathfinding.getG(tile, unitRange,unitMoveType)

func getG(possibleParent,unitRange,unitMoveType):
	if !tile.occupant:
		var parentG  = possibleParent.pathfinding.G
		var projectedG = parentG + getMovementCost(unitMoveType)
		#if we haven't stepped here, or movement is cheaper...
		if G == -1 or projectedG < G:
			assignG(possibleParent,projectedG)
			if G < unitRange:
				for neighbor in neighbors:
					neighbor.pathfinding.getG(tile,unitRange,unitMoveType)

func assignG(newParent,newG):
	G = newG
	parent = newParent
	emit_signal("inRange")

func getMovementCost(unitMoveType):
	return 1

func clearG():
	parent = null
	G = -1 
	emit_signal("noRange")
	goingTo = null
	comingFrom = null

func getGList(tile,list = null):
	if list == null:
		list = UnitPath.new()
	list.add(tile)
	if parent == null:
		return list
	else:
		return parent.pathfinding.getGList(parent,list)

func getCustomList(tile):
	var glist = getGList(tile)
	var list = UnitPath.new(true)
	list.add(glist.getOrigin())
	if  not glist.isOnlyTile() and glist.getOrigin().pathfinding.goingTo != null and list.isAdjacent(list.getOrigin(),list.getOrigin().pathfinding.goingTo):
		var nextTile = list.getOrigin().pathfinding.goingTo
		list.add(nextTile)
		while isValidTile(nextTile,tile,list):
			if not list.isAdjacent(nextTile,nextTile.pathfinding.goingTo):
				return revertToGList(list,glist)
			nextTile = nextTile.pathfinding.goingTo
			list.add(nextTile)
	else:
		return revertToGList(list,glist)
	var stats = list.getOrigin().occupant.stats
	if glist.getEnd() != list.getEnd() or list.getTotalCost() > stats.movement_range:
		return revertToGList(list,glist)
		
	return list
func isValidTile(nextTile,tile,list):
	return nextTile.pathfinding.goingTo != null and nextTile != tile and not list.isInList(tile)

func revertToGList(list,glist):
	for tile in list.getList():
		tile.pathfinding.goingTo = null
	for tile in glist.getList():
		tile.pathfinding.goingTo = glist.getNext(tile)
	return glist
