extends State

signal sendCellData(cell,occupant)
var isOccupantFromActivePlayer = false
var inMenu = false
func _ready():
	GameEvents.connect('selectedEndTurnIdle',self,'endTurn')
	GameEvents.connect('selectedCancelIdle',self,'cancel')
	GameEvents.connect("popUpIdleMenu",self,"idleMenu")
	GameEvents.connect("unitMenuDespawns",self,"cancel")
func newState():
	GameEvents.emit_signal("clearButtons")

func input(event):
	if !inMenu:
		if Input.is_action_just_pressed("ui_accept"):
			GameEvents.emit_signal("cellSelected")
		else:
			GameEvents.emit_signal("moveCursor",event)

func activateCell():
	GameEvents.emit_signal("cellStateSelected","idle")

func foundOccupant(cell,occupant):
	GameEvents.emit_signal("isOccupantFromActivePlayer",self,occupant)
	if isOccupantFromActivePlayer and !occupant.tired:
		print(cell.name + "'s occupant has been activated!(idle)")
		emit_signal("sendCellData",cell,occupant)
		print(cell)
		print(occupant)
		emit_signal("switchState","Movement")
	else:
		GameEvents.emit_signal("popUpIdleMenu",cell)
	isOccupantFromActivePlayer = false
func structureActivated(tile):
	inMenu = true
	GameEvents.emit_signal("popUpStructureMenu",tile)
	

	
func cancel():
	inMenu = false
func idleMenu(tile):
	inMenu = true
func endTurn():
	inMenu = false
	emit_signal("switchState","BeginTurn")

