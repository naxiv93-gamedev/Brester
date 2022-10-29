extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var unitScene
var players = [1,2,3,4]
# Called when the node enters the scene tree for the first time.
func _ready():
	for player in players:
		var playerUnitManager = Node.new()
		playerUnitManager.name = "Player"+str(player)+"UnitManager"
		add_child(playerUnitManager)
	for unitPos in get_used_cells():
		var unitInstance = unitScene.instance()
		unitInstance.init(unitPos,["#000000","#692d3a","#ad2139","#bd4d4d","#000000","#000000","#000000","#000000","#000000"])
		$Player1UnitManager.add_child(unitInstance)
		GameEvents.emit_signal("unitSpawned",unitPos,unitInstance)
		set_cellv(unitPos,-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
