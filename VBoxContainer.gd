extends VBoxContainer

export(Script) var buttonScript

func _ready():
	GameEvents.connect("finishedMovement",self,"finishedMovement")

func addButton(name):
	var newButton = Button.new()
	newButton.set_script(buttonScript)
	newButton.text = name
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
	margin_top = occupant.position.y - 16
	margin_left = occupant.position.x + 16
	
	addButton("Cancel")
	addButton("Wait")
	if destination.hasNeighborEnemies():
		addButton("Attack")
	if destination.hasCapturableBase():
		addButton("Capture")
	$Cancel.grab_focus()
