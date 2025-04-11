extends Label


func _process(_delta):
	self.text = "Lives : " + str(Global.lives)
