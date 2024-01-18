extends Node2D



func _on_acceptance_pressed():
	$RichText.clear()
	$RichText.text = ""
	self.hide()
	get_tree().get_root().get_node("Main/Card_Holder").run_disable_check()
	get_tree().get_root().get_node("Main/Game_Manager").show_everything()
	
