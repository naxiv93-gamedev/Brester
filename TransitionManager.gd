extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var mapScene

var player1Name
var player2Name
var timer
var nextScene
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("startGame",self,"startGame")


func startGame(player1Name,player2Name):
	self.player1Name = player1Name
	self.player2Name = player2Name
	nextScene = mapScene
	#$CurrentScene.get_child(0).queue_free()
	$Transition/ColorRect/AnimationPlayer.play("transitionIn")
	#var map = mapScene.instance()
	#$CurrentScene.add_child(map)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func timerStopped():
	var sceneInstance = nextScene.instance()
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(sceneInstance)
	$Transition/ColorRect/AnimationPlayer.play("transitionOut")
	timer.queue_free()






func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'transitionIn':
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout",self,"timerStopped")
		timer.start(.5)
		
