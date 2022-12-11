extends State

var occupant 
var originCell
func _ready():
	
	GameEvents.connect("cancelMovement",self,"cancelMovement")
	GameEvents.connect("suitableCell", self,"suitableCell")
func newState():
	GameEvents.emit_signal("clearGData")
	print(occupant)
	print(originCell)
	originCell.occupant = occupant
	originCell.pathfinding.startG(occupant.stats.movement_range,1)
	GameEvents.emit_signal("drawPath",originCell.pathfinding.getCustomList(originCell))
func input(event):

	if Input.is_action_just_pressed("ui_accept"):

		GameEvents.emit_signal("cellSelected")
	else:
		GameEvents.emit_signal("moveCursor",event)

func activateCell():
	GameEvents.emit_signal("cellStateSelected","movement")

func cancelMovement():
	GameEvents.emit_signal("clearGData")
	emit_signal("switchState","Idle")

func suitableCell(cell):
	var list  = cell.pathfinding.getCustomList(cell) as UnitPath
	occupant.startMove(list)
	emit_signal("switchState","Moving")

func _on_Idle_sendCellData(cell, occupant):
	print("Ima sending ma signal")
	self.originCell = cell
	self.occupant = occupant



func _on_Moving_resetMovement():
		occupant.teleport(originCell)
		newState()



func _on_Combat_requestUnit(combat):
	combat.attacker = occupant

