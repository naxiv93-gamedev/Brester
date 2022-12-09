extends TileMap

enum tileIndexes {
	INFANTRY_P1,
	INFANTRY_P2 
}
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var unitScene
var players = [1,2]
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect('sendUnits',self,'onUnitPetition')
	call_deferred("init")
	
func init():
	for player in players:
		var playerUnitManager = Node.new()
		playerUnitManager.name = "Player"+str(player)+"UnitManager"
		add_child(playerUnitManager)
	for unitPos in get_used_cells():
		var cellTitleID = get_cellv(unitPos)
		var tileName = tile_set.tile_get_name(cellTitleID)
		var unitInstance = null
		var player = null
		match tileName:
			'p1Unit':
				unitInstance = unitScene.instance()
				$Player1UnitManager.add_child(unitInstance)
				player = "player1"
			'p2Unit':
				unitInstance = unitScene.instance()
				$Player2UnitManager.add_child(unitInstance)
				player = "player2"
		GameEvents.emit_signal("unitSpawned",unitPos,unitInstance,player)
		set_cellv(unitPos,-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
