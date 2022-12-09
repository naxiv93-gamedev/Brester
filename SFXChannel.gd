extends AudioStreamPlayer

export(AudioStreamSample) var cursorMove
export(AudioStreamSample) var accept
# Called when the node enters the scene tree for the first time.

func _ready():
	GameEvents.connect("cellSelected",self,"playAccept")
	GameEvents.connect("highlightedNewCell",self,"switchSelectedTile")
	GameEvents.connect("playAccept", self, "playAccept")

func switchSelectedTile(oldTile,newTile):
	playSwitch()

func playAccept():
	stream = accept
	play()

func playSwitch():
	stream = cursorMove
	play()
