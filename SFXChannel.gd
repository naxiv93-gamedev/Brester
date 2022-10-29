extends AudioStreamPlayer

export(AudioStreamSample) var cursorMove
export(AudioStreamSample) var accept
# Called when the node enters the scene tree for the first time.
func _ready():
	GameEvents.connect("cellSelected",self,"cellSelected")
	GameEvents.connect("highlightedNewCell",self,"switchSelectedTile")
func switchSelectedTile(oldTile,newTile):
	stream = cursorMove
	play()
func cellSelected(cell):
	stream = accept
	play()
