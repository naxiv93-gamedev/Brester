extends VBoxContainer

export(Script) var buttonScript

var money

func _ready():
	GameEvents.connect("clearButtons",self,"clearButtons")
	GameEvents.connect("validCombatTile",self,"validCombatTile")
	GameEvents.connect("finishedMovement",self,"finishedMovement")
	GameEvents.connect("tileSelectedCombat", self, "beforeCombat")
	GameEvents.connect("popUpIdleMenu",self,"idleMenu")
	GameEvents.connect("structureActivated",self,"spawnUnitMenu")
func addButton(name,text):
	var newButton = Button.new()
	newButton.set_script(buttonScript)
	newButton.text = text
	newButton.name = name
	add_child(newButton)
	newButton.connect("selected",self,"processChoice")

func processChoice(name):
	GameEvents.emit_signal("playAccept")
	GameEvents.emit_signal("selected"+name)
	clearButtons()

func clearButtons():
	for child in get_children():
		remove_child(child)

func finishedMovement(occupant,destination):
	setPosition(occupant.position)
	rect_size.x = 0
	rect_size.y = 0
	addButton("CancelMoving", "Cancel")
	addButton("WaitMoving" , "Wait")
	if destination.hasNeighborEnemies():
		addButton("AttackMoving", "Attack")
	if occupant.stats.canCapture and destination.hasCapturableBase():
		addButton("CaptureMoving", "Capture")
	destination.isStructureFromActivePlayer = false
	$CancelMoving.grab_focus()

func validCombatTile(tile):
	addButton("SwitchCombat", "Switch target")
	addButton("CancelCombat", "Cancel movement")
	addButton("AttackCombat" , "Attack")
	setPosition(tile.position)
	$SwitchCombat.grab_focus()

func idleMenu(tile):
	clearButtons()
	setPosition(tile.position)
	addButton("CancelIdle","Cancel")
	addButton("EndTurnIdle", "End Turn")

func spawnUnitMenu(tile):
	setPosition(tile.position)
	GameEvents.emit_signal("askPlayerMoney",self)
	addButton("Infantry","Infantry - 1000 G")
	if(money < 1000):
		$Infantry.disabled = true
	addButton("Tank","Tank - 6000 G")
	if(money < 6000):
		$Tank.disabled = true
	addButton("Bcopter","Battle Copter - 7000 G")
	if(money < 7000):
		$Bcopter.disabled = true
	addButton("Antiair","Antiair - 8000 G")
	if(money < 8000):
		$Antiair.disabled = true
	$Infantry.grab_focus()

func setPosition(pos):
	rect_size.y = 0
	var xPos =  pos.x + 16
	var yPos = pos.y - 16
	rect_position.x = xPos
	rect_position.y = yPos
	if (rect_position.x +rect_size.x) > get_viewport_rect().size.x:
		rect_position.x -= rect_size.x
		rect_position.x -= 64
	if (rect_position.y +rect_size.y) > get_viewport_rect().size.y:
		rect_position.y -= rect_size.y
		rect_position.y -= 64
