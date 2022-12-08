extends Resource
class_name Structure
export(String) var activationSignal
export(Texture) var structureTexture
export(Resource) onready var stats
var propietor
func activate(pos):
	GameEvents.emit_signal(activationSignal,pos)
