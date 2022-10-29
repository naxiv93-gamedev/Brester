extends Resource
class_name Structure
export(String) var activationSignal
export(Texture) var structureTexture
var propietor
func activate(pos):
	GameEvents.emit_signal(activationSignal,pos)
