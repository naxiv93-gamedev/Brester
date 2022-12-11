extends TileMap


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
		GameEvents.emit_signal("unitSpawned",unitPos,tileName)
		set_cellv(unitPos,-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Referee_sendUnit(unit):
	pass # Replace with function body.
