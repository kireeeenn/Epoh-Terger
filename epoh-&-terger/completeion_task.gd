extends Label


func _process(_delta):
	self.text = str(Global.wins) + " / " + str(Global.completion)
