extends Label

func _physics_process(delta):
	text = "Documents Destroyed: \n" + str(Globals.docs_destroyed) + " / " + str(Globals.doc_goal)
