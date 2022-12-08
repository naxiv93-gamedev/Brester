extends State


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal resetMovement()
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("finishedMovement",self,"finishedMovement")
	GameEvents.connect("selectedCancel",self,"selectedCancel")
	GameEvents.connect("selectedWait",self,"selectedWait")
	GameEvents.connect("selectedAttack",self,"selectedAttack")
func finishedMovement(occupant,destination):
	GameEvents.emit_signal("popUpMenu")
	GameEvents.emit_signal("clearGData")
	#emit_signal("switchState","Idle")

func selectedCancel():
	emit_signal("resetMovement")
	emit_signal("switchState","Movement")

func selectedWait():
	emit_signal("switchState","Idle")

func selectedAttack():
	emit_signal("switchState", "Combat")

func selectedCapture():
	pass
