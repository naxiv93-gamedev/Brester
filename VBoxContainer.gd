extends VBoxContainer

export(Script) var buttonScript

func _ready():
	GameEvents.connect("validCombatTile",self,"validCombatTile")
	GameEvents.connect("finishedMovement",self,"finishedMovement")
	GameEvents.connect("tileSelectedCombat", self, "beforeCombat")
	
func addButton(name,text):
	var newButton = Button.new()
	newButton.set_script(buttonScript)
	newButton.text = text
	newButton.name = name
	add_child(newButton)
	newButton.connect("selected",self,"processChoice")

func processChoice(name):
	GameEvents.emit_signal("selected"+name)
	clearButtons()

func clearButtons():
	for child in get_children():
		remove_child(child)

func finishedMovement(occupant,destination):
	rect_position.y = occupant.position.y - 16
	rect_position.x  = occupant.position.x + 16
	addButton("CancelMoving", "Cancel")
	addButton("WaitMoving" , "Wait")
	if destination.hasNeighborEnemies():
		addButton("AttackMoving", "Attack")
	if destination.hasCapturableBase():
		addButton("CaptureMoving", "Capture")
	$CancelMoving.grab_focus()

func validCombatTile(tile):
	addButton("SwitchCombat", "Switch target")
	addButton("CancelCombat", "Cancel movement")
	addButton("AttackCombat" , "Attack")
	rect_position.y = tile.position.y - 16
	rect_position.x  = tile.position.x + 16
	$SwitchCombat.grab_focus()
	
