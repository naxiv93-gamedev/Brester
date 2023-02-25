extends State


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var income = 0 
var player = ""
var firstTime = true
func _ready():
	GameEvents.connect("startGame",self,"startTurn")
	call_deferred("firstNewState")
func firstNewState():
	GameEvents.emit_signal("askPlayerName",self)
	GameEvents.emit_signal("askPlayerIncome", self)
func newState():
	if firstTime:
		firstTime =false 
	else:
		GameEvents.emit_signal("askPlayerName",self)
		GameEvents.emit_signal("askPlayerIncome", self)
		GameEvents.emit_signal("editBeginTurnLabels", player,income)
		GameEvents.emit_signal("requestPlayerInfoEdit",player,income)
	GameEvents.emit_signal("beginTurn")

func startTurn():
	emit_signal("switchState","Idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
