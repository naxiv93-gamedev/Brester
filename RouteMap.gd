extends TileMap

enum RoutePoints{
	DEFAULT,
	LASTFROMRIGHT,
	LASTFROMLEFT,
	LASTFROMDOWN,
	LASTFROMUP,
	FIRSTTORIGHT,
	FIRSTTOLEFT,
	FIRSTTODOWN,
	FIRSTTOUP,
	VERTICAL,
	HORIZONTAL,
	RIGHTUP,
	LEFTUP,
	RIGHTDOWN,
	LEFTDOWN
}
func _ready():
	GameEvents.connect("drawPath",self,"drawPath")
func drawPath(list):
	for cell in get_used_cells():
		set_cellv(cell,-1)
	for tile in list.getList():
		var coord = RoutePoints.DEFAULT
		if not list.isOnlyTile():
			if list.isEnd(tile):

				match list.comingFrom(tile):
					Vector2.UP:
						coord = RoutePoints.LASTFROMUP
					Vector2.DOWN:
						coord = RoutePoints.LASTFROMDOWN
					Vector2.LEFT:
						coord = RoutePoints.LASTFROMLEFT
					Vector2.RIGHT:
						coord = RoutePoints.LASTFROMRIGHT
			elif list.isOrigin(tile):
				match list.goingTo(tile):
					Vector2.UP:
						coord = RoutePoints.FIRSTTOUP
					Vector2.DOWN:
						coord = RoutePoints.FIRSTTODOWN
					Vector2.LEFT:
						coord = RoutePoints.FIRSTTOLEFT
					Vector2.RIGHT:
						coord = RoutePoints.FIRSTTORIGHT
			else:
				if list.isHorizontal(tile):
					coord = RoutePoints.HORIZONTAL
				elif list.isVertical(tile):
					coord = RoutePoints.VERTICAL
				else:
					var comingFrom = list.comingFrom(tile)
					var goingTo = list.goingTo(tile)
					if(comingFrom == Vector2.RIGHT and goingTo == Vector2.DOWN)or(comingFrom == Vector2.UP and goingTo == Vector2.LEFT):
						coord = RoutePoints.RIGHTDOWN
					elif(comingFrom == Vector2.RIGHT and goingTo == Vector2.UP)or(comingFrom == Vector2.DOWN and goingTo == Vector2.LEFT):
						coord = RoutePoints.RIGHTUP
					elif(comingFrom == Vector2.LEFT and goingTo == Vector2.DOWN)or(comingFrom == Vector2.UP and goingTo == Vector2.RIGHT):
						coord = RoutePoints.LEFTDOWN
					elif(comingFrom == Vector2.LEFT and goingTo == Vector2.UP)or(comingFrom == Vector2.DOWN and goingTo == Vector2.RIGHT):
						coord = RoutePoints.LEFTUP
						
		set_cellv(tile.getPosition(),coord)
		update_dirty_quadrants()
