extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.visible = false


func showDamage(life):
	if !$ColorRect.visible:
		$ColorRect.visible = true
	$ColorRect/RichTextLabel.text = str(ceil(life/10))
