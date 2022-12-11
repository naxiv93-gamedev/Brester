extends Resource
class_name Structure
export(String) var structureName
export(String) var activationSignal
export(Texture) var structureTexture
export(Resource) onready var stats

var sprite = null
func init(colorsArray):
	sprite = Sprite.new()
	sprite.texture = structureTexture
	sprite.material = load("res://Shaders/PaletteSwapper.tres") as ShaderMaterial
	var uniqueMaterial = sprite.material.duplicate()
	sprite.material = uniqueMaterial
	for i in colorsArray.size():
		sprite.material.set_shader_param("color" + str(i),Color(colorsArray[i]))
func activate(pos):
	GameEvents.emit_signal(activationSignal,pos)
