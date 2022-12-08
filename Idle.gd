extends State


signal sendCellData(cell,occupant)
func input(event):

	if Input.is_action_just_pressed("ui_accept"):
		GameEvents.emit_signal("cellSelected")
	else:
		GameEvents.emit_signal("moveCursor",event)
func activateCell():
	GameEvents.emit_signal("cellStateSelected","idle")

func foundOccupant(cell,occupant):
	print(cell.name + "'s occupant has been activated!(idle)")
	emit_signal("sendCellData",cell,occupant)
	emit_signal("switchState","Movement")

