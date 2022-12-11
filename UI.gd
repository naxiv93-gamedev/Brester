extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("editBeginTurnLabels",self,"editBeginTurnLabels")
	GameEvents.connect("editPlayerUI",self,"newTurn")
func newTurn(player):
	$PlayerInfo/PlayerName.text = player['name']+"'s turn"
	$PlayerInfo/Money.text = "Money: " + str(player['money'])+"G"


func editBeginTurnLabels(player,income):
	$BeginTurn/PlayerName.text = "Begin " + player + "'s turn"
	$BeginTurn/Income.text = "Income: " + str(income) + "G"
	$BeginTurn.visible = true
func _on_BeginTurn_gui_input(event):
	if Input.is_action_just_pressed("ui_accept"):
		$BeginTurn.visible = false
		GameEvents.emit_signal("startGame")
