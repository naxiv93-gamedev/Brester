extends Control
var winner_name = null


func _ready():
	$AudioStreamPlayer.play()
	GameEvents.emit_signal("requestWinner",self)
	call_deferred("setLabel")

func setLabel():
	$Label.text = 'Winner: ' + winner_name + "!!"
func _on_btn_Exit_pressed():
	get_tree().quit()
func _on_btn_MainMenu_pressed():
	GameEvents.emit_signal("backToMenu")
