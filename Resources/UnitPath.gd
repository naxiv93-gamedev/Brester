class_name UnitPath
var list = []
var custom = false
func _init(isCustom = false):
	if isCustom:
		custom = isCustom
func add(tile):
	if custom:
		list.push_back(tile)
	else:	
		list.push_front(tile)


func validTile(tile):
	return not list.has(tile)
func isInList(tile):
	return list.has(tile)
func getTotalCost():
	var sum  = 0
	for tile in list:
		if tile != getOrigin():
			sum += tile.cost
	return sum
		


func getNext(tile):
	var index = list.find(tile)
	if isEnd(tile):
		return null
	else:
		return list[index + 1]

func getPrevious(tile):
	var index = list.find(tile)
	if isOrigin(tile):
		return null
	else:
		return list[index - 1]

func getList():
	return list

func getOrigin():
	return list.front()
func getEnd():
	return list.back()

func isOnlyTile():
	return getOrigin() == getEnd()

func isOrigin(tile):
	return list.front() == tile

func isEnd(tile):
	return list.back() == tile

func comingFrom(tile):
	return getPrevious(tile).getPosition() - tile.getPosition() 
func goingTo(tile):
	return tile.getPosition() - getNext(tile).getPosition()
func isAdjacent(tile,destinationTile):
	for neighbor in tile.pathfinding.neighbors:
		if neighbor == destinationTile:
			return true
	return false
func isHorizontal(tile):
	return comingFrom(tile) == goingTo(tile) and goingTo(tile).abs() == Vector2.RIGHT
func isVertical(tile):
	return comingFrom(tile) == goingTo(tile) and goingTo(tile).abs() == Vector2.DOWN
