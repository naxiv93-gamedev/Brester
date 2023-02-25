extends Control

var namePlayer1 = null
var namePlayer2 = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_btn_Start_pressed():
	if !namePlayer1:
		namePlayer1 = "Player 1"
	if !namePlayer2: 
		namePlayer2 = "Player 2"
	GameEvents.emit_signal("startGame",namePlayer1,namePlayer2)
func _on_btn_Exit_pressed():
	get_tree().quit()

func _on_input_name1_text_changed(text):
	namePlayer1 = text
func _on_input_name2_text_changed(text):
	namePlayer2 = text
	
func clearTexts():
	$input_name1.text = ""
	$input_name2.text = ""

func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		if $input_name1.has_focus():
			$input_name2.grab_focus()
		else:
			$input_name1.grab_focus()
		clearTexts()


