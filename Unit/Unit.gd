extends Node2D
class_name Unit
export(Resource) var stats
signal finishedTween()

var list
var lastTile
var currentCell
var tired = false


func _ready():
	GameEvents.connect("selectedCancel",self,"clearGData")

func init(pos,colorsArray):
	var uniqueMaterial = $Sprite.material.duplicate()
	$Sprite.material = uniqueMaterial
	
	var size = $Sprite.texture.get_size()
	$Sprite.texture = stats.texture
	self.position = (pos * size) + (size/2)
	for i in colorsArray.size():
		$Sprite.material.set_shader_param("color" + str(i),Color(colorsArray[i]))

func startMove(moveList):
	list = moveList
	var origin = list.getOrigin()
	origin.occupant = null
	var next = list.getNext(origin)
	
	startTween(next)

func faceLeft():
	$Sprite.scale.x = -1
func startTween(tile):
		tile.occupant = self
		lastTile = tile
		$Tween.interpolate_property(self,"position",self.position,tile.position,.15,Tween.TRANS_CIRC,Tween.EASE_OUT)
		$Tween.start()
		

func getTired():
	modulate = "#999999"
	tired = true

func getRecovered():
	modulate = "#ffffff"
	tired = false

func teleport(cell):
	self.position = cell.position


func _on_Tween_tween_completed(object, key):
	var next = list.getNext(lastTile)
	if next:
		lastTile.occupant = null
		startTween(next)
	else:
		list.getEnd().occupant = self
		GameEvents.emit_signal("finishedMovement",self,list.getEnd())
func clearGData():
	if list:
		for cell in list.getList():
			if !list.isOrigin(cell):
				cell.occupant = null
	list = null
	lastTile = null


func receiveDamage(damage):
	stats.life -=  damage
	$Control.showDamage(stats.life)
	if stats.life <= 0:
		GameEvents.emit_signal("unitDied",self)
		queue_free()
	
