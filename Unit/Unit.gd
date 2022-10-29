extends Node2D

export(Resource) var stats

func _ready():
	pass # Replace with function body.

func init(pos,colorsArray):
	var size = $Sprite.texture.get_size()
	self.position = (pos * size) + (size/2)
	for i in colorsArray.size():
		$Sprite.material.set_shader_param("color" + str(i),Color(colorsArray[i]))
