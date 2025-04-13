extends Label


func _process(_delta):
	self.text = "Battery lives: " + str(Global.lives)
