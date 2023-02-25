extends Node
export(AudioStreamSample) var cursorMove
export(AudioStreamSample) var accept
export(AudioStreamSample) var explosion
export(AudioStreamMP3) var player1BGM
export(AudioStreamMP3) var player2BGM
# Called when the node enters the scene tree for the first time.

func _ready():
	GameEvents.connect("cellSelected",self,"playAccept")
	GameEvents.connect("highlightedNewCell",self,"switchSelectedTile")
	GameEvents.connect("playAccept", self, "playAccept")
	GameEvents.connect("beginPlayerTurn",self,"playPlayerBGM")

func findChannel():
	for channel in $SFX.get_children():
		channel = channel as AudioStreamPlayer 
		print(channel.playing)
		if !channel.playing:
			return channel
		elif channel.stream.get_length() <= 2:
			return channel
func switchSelectedTile(oldTile,newTile):
	playSwitch()

func playAccept():
	var channel = findChannel()
	channel.stream = accept
	channel.play()

func playSwitch():
	var channel = findChannel()
	channel.stream = cursorMove
	channel.play()

func playExplosion():
	var channel = findChannel()
	channel.stream = explosion
	channel.play()

func playPlayerBGM(player):
	match player['number']:
		'player1':
			playPlayer1BGM()
		'player2':
			playPlayer2BGM()
		
func playPlayer1BGM():
	var channel = $BGM/BGMChannel
	channel.stream = player1BGM
	channel.play()

func playPlayer2BGM():
	var channel = $BGM/BGMChannel
	channel.stream = player2BGM
	channel.play()

