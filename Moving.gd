extends State


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var endTile = null
signal resetMovement()
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("finishedMovement",self,"finishedMovement")
	GameEvents.connect("selectedCancelMoving",self,"selectedCancel")
	GameEvents.connect("selectedWaitMoving",self,"selectedWait")
	GameEvents.connect("selectedAttackMoving",self,"selectedAttack")
	GameEvents.connect("selectedCaptureMoving",self,"selectedAttack")
func finishedMovement(occupant,destination):
	endTile = destination
	GameEvents.emit_signal("popUpMenu")
	GameEvents.emit_signal("clearGData")
	#emit_signal("switchState","Idle")

func selectedCancel():
	endTile.occupant = null
	endTile = null
	emit_signal("resetMovement")
	emit_signal("switchState","Movement")

func selectedWait():
	endTile.occupant.getTired()
	emit_signal("switchState","Idle")

func selectedAttack():
	emit_signal("switchState", "Combat")

func selectedCapture():
	endTile.occupant.getTired()
	pass


