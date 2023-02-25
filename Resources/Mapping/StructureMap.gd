extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("init")
func init():
	for pos in get_used_cells():
		var cellTitleID = get_cellv(pos)
		var tileName = tile_set.tile_get_name(cellTitleID)
		var structure = null
		var player = null

		match tileName:
			'cityNeutral':
				structure = load("res://Database/objects/Structures/City.tres")
				player = "Neutral"
			'cityP1':
				structure = load("res://Database/objects/Structures/City.tres")
				player = "Player1"
			'cityP2':
				structure = load("res://Database/objects/Structures/City.tres")
				player = "Player2"
			'factoryNeutral':
				structure = load("res://Database/objects/Structures/Factory.tres")
				player = "Neutral"
			'factoryP1':
				structure = load("res://Database/objects/Structures/Factory.tres")
				player = "Player1"
			'factoryP2':
				structure = load("res://Database/objects/Structures/Factory.tres")
				player = "Player2"
			'hqNeutral':
				structure = load("res://Database/objects/Structures/HQ.tres")
				player = "Neutral"
			'hqP1':
				structure = load("res://Database/objects/Structures/HQ.tres")
				player = "Player1"
			'hqP2':
				structure = load("res://Database/objects/Structures/HQ.tres")
				
				player = "Player2"
		GameEvents.emit_signal("structureFound",pos,structure,player)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
