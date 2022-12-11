extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var unitScene
export (Resource) var tankStats
export (Resource) var copterStats
export (Resource) var antiairStats
export (Resource) var infantryStats


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
		var unitInstance = unitScene.instance()
		var player = null
		
		match tileName:
			'p1Unit':
				unitInstance.stats = infantryStats.duplicate()
				$Player1UnitManager.add_child(unitInstance)
				player = "player1"
			'p2Unit':
				unitInstance.stats = infantryStats.duplicate()
				$Player2UnitManager.add_child(unitInstance)
				player = "player2"
			'P1Bcopter':
				unitInstance.stats = copterStats.duplicate()
				$Player1UnitManager.add_child(unitInstance)
				player = "player1"
			'P2Bcopter':
				unitInstance.stats = copterStats.duplicate()
				$Player2UnitManager.add_child(unitInstance)
				player = "player2"
			'P1Antiair':
				unitInstance.stats = antiairStats.duplicate()
				$Player1UnitManager.add_child(unitInstance)
				player = "player1"
			'P2Antiair':
				unitInstance.stats = antiairStats.duplicate()
				$Player2UnitManager.add_child(unitInstance)
				player = "player2"
			'P1Tank':
				print("added")
				unitInstance.stats = tankStats.duplicate()
				$Player1UnitManager.add_child(unitInstance)
				player = "player1"
			'P2Tank':
				unitInstance.stats = tankStats.duplicate()
				$Player2UnitManager.add_child(unitInstance)
				player = "player2"
			
		GameEvents.emit_signal("unitSpawned",unitPos,unitInstance,player)
		set_cellv(unitPos,-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
