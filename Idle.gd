extends State

signal sendCellData(cell,occupant)
var isOccupantFromActivePlayer = false

func newState():
	pass
func input(event):

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
	isOccupantFromActivePlayer = false
func openMenu():
	pass
