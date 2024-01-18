extends Node2D


var state : int = 0


func _on_proceed_pressed():
	if state == 0:
		global.player_1.player_name = $Player_1_Input/Player_1_Name.text
		global.player_1.pronoun = [$Player_1_Input/Pronoun/L1.text,$Player_1_Input/Pronoun/L2.text,$Player_1_Input/Pronoun/L2.text]
		state = 1
		$Player_1_Input.hide()
		$Player_2_Input.show()
	else:
		global.player_2.player_name = $Player_2_Input/Player_2_Name.text
		global.player_2.pronoun = [$Player_2_Input/Pronoun/L1.text,$Player_2_Input/Pronoun/L2.text,$Player_2_Input/Pronoun/L2.text]
		get_tree().change_scene_to_file("res://turn_over.tscn")
