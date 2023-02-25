extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var mainMenuScene
export(PackedScene) var mapScene
export(PackedScene) var victoryScene
var player1Name
var player2Name
var timer
var nextScene
var winner
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("startGame",self,"startGame")
	GameEvents.connect("requestPlayerNames", self, "givePlayerNames")
	GameEvents.connect("foundWinner",self,"foundWinner")
	GameEvents.connect("backToMenu",self,"backToMenu")
	GameEvents.connect("requestWinner",self,"giveWinner")
func startGame(player1Name,player2Name):
	self.player1Name = player1Name
	self.player2Name = player2Name
	nextScene = mapScene
	#$CurrentScene.get_child(0).queue_free()
	$Transition/ColorRect/AnimationPlayer.play("transitionIn")
	#var map = mapScene.instance()
	#$CurrentScene.add_child(map)
	

func givePlayerNames(referee):

	referee.player1['name'] = player1Name
	referee.player2['name'] = player2Name

func timerStopped():
	var sceneInstance = nextScene.instance()
	$CurrentScene.get_child(0).queue_free()
	$CurrentScene.add_child(sceneInstance)
	$Transition/ColorRect/AnimationPlayer.play("transitionOut")
	timer.queue_free()

func foundWinner(winner):
	nextScene = victoryScene
	self.winner = winner
	$Transition/ColorRect/AnimationPlayer.play("transitionIn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'transitionIn':
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout",self,"timerStopped")
		timer.start(.5)

func backToMenu():
	nextScene = mainMenuScene
	$Transition/ColorRect/AnimationPlayer.play("transitionIn")

func giveWinner(victoryScene):
	victoryScene.winner_name = winner
