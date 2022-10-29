extends TileMap


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal structureFound(pos,structure)

# Called when the node enters the scene tree for the first time.
func _ready():
	for pos in get_used_cells():
		var structure = load("res://Structure/objects/Factory.tres")
		emit_signal("structureFound",pos,structure)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
