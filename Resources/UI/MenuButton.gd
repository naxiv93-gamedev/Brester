extends Button


signal selected()
func _ready():
	self.connect("pressed",self,"selected")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func selected():
	emit_signal("selected",self.name)
