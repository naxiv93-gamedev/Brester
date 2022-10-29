extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var firstTile = true

var spriteSize
# Called when the node enters the scene tree for the first time.

func init(spriteSize):
	self.spriteSize = spriteSize
	$Sprite.position += spriteSize/2
	$HighlightSprite.position += spriteSize/2
	$HighlightAnimationPlayer.play("highlight")


func _on_TileManager_switchedTileHighlight(newTile):
	$Tween.interpolate_property(self,"position",self.position,newTile*spriteSize,.15,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$Tween.start()

