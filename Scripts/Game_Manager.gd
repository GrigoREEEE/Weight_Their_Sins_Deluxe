extends Node2D

# AI values DO NOT TOUCH
var api_key : String = "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"
var url : String = "Https://api.openai.com/v1/chat/completions"
var temperature : float = 1.1
var max_tokens : int = 1024
var headers = ["Content-type: application/json", "Authorization: Bearer " + api_key]
var model : String = "gpt-3.5-turbo"#"gpt-3.5-turbo"
var messages = []
var request : HTTPRequest

# Request values
var text_message_person_1 : String
var text_message_person_2 : String

# parent resources
var turn_over : Node
var game_over : Node
var card_holder : Node
var interface : Node

# Round-handling values
var crimes : Dictionary = {"Person 1": [], "Person 2": []}
var round : int = 0
var final : bool = false
var loser : String
var return_crimes : Array

# Budget
var draws : int = 1
var cost : int = 2
var stored_cost : int = cost


func _ready():
	$Confession.hide()
	$Investigation/Budget_Text.text = "Current Investigation Budget: " + str(global.player_dict[global.current_player].budget) + "\n" + "Number of Draws:      " + str(draws) + "      Cost: " + str(cost) + "\nBudget Next Turn: " + str((global.player_dict[global.current_player].budget - cost)) + " + (2)"
	$Round_Info/Player_Name.text = global.player_dict[global.current_player].player_name
	turn_over = get_tree().get_root().get_node("Main/turn_over")
	game_over = get_tree().get_root().get_node("Main/game_over")
	card_holder = get_tree().get_root().get_node("Main/Card_Holder")
	interface = get_tree().get_root().get_node("Main/Interface")

	$Round_Info/Round.text = str(round)
	$Round_Info/Player_1_Sins.text = str(0)
	$Round_Info/Player_2_Sins.text = str(0)
	$Round_Info/Player_1_Name.text = global.player_1.player_name
	$Round_Info/Player_2_Name.text = global.player_2.player_name
	turn_over.hide()
	game_over.hide()
	request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_request_completed)

	
func dialogue_request(player_dialogue):
	messages.append({
		"role": "user",
		"content": player_dialogue
		})
	var body = JSON.new().stringify({
		"messages": messages,
		"temperature": temperature,
		"max_tokens": max_tokens,
		"model": model
	})	
	var send_request = request.request(url, headers, HTTPClient.METHOD_POST, body)
	if send_request != OK:
		print("Error!")
		
func _on_request_completed (result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var ai_response = response["choices"][0]["message"]["content"]
	print(ai_response)
	if (!final):
		end_round_mode_1(ai_response)
	else:
		end_game(ai_response)
		
			
func end_game(ai_response):
	var get = ""
	if (loser == global.player_dict["Player 1"].player_name):
		get = "Player 1"
	else:
		get = "Player 1"
	print(ai_response)
	$Display.hide()
	$Confession.hide()
	$Investigation.hide()
	card_holder.hide()
	interface.get_node("UI").hide()
	interface.get_node("Lady_Justice").hide()
	game_over.show()
	game_over.get_node("RichText").push_color(Color("Black"))
	game_over.get_node("RichText").add_text(ai_response)
	get_tree().get_root().get_node("Main/Taco_Bell").play()

func hide_everything():
	$Round_Info.hide()
	$Display.hide()
	$Investigation.hide()
	$Confession.hide()
	card_holder.hide()
	interface.get_node("UI").hide()
	interface.get_node("Lady_Justice").hide()
	
func show_everything():
	$Round_Info.show()
	$Display.show()
	$Investigation.show()
	$Confession.show()
	card_holder.show()
	interface.get_node("UI").show()
	interface.get_node("Lady_Justice").show()
	
	
func end_round_mode_1(ai_response):
	var guilty : String = ai_response.left(15)
	var gp : String = ""
	round += 1
	
	if (global.player_dict["Player 1"].player_name in guilty):
		guilty = "Player 1"
		global.player_dict["Player 1"].guilt.append(text_message_person_2.right(-13))
		global.player_dict["Player 1"].sins += 1
	else:
		guilty = "Player 2"
		global.player_dict["Player 2"].guilt.append(text_message_person_1.right(-13))
		global.player_dict["Player 2"].sins += 1

	update_score()
		
	if (global.player_dict["Player 1"].sins == 3 or global.player_dict["Player 2"].sins == 3):
		final = true
		if (global.player_dict["Player 1"].sins > global.player_dict["Player 2"].sins):
			return_crimes = global.player_dict["Player 1"].guilt
			loser = global.player_dict["Player 1"].player_name
		else:
			return_crimes = global.player_dict["Player 2"].guilt
			loser = global.player_dict["Player 2"].player_name
		print("conclusion requested")
		var conclusion = "I want you to pretend that you are a stern judge that was granted divine authority. " + loser + " has commited the following crimes: " + return_crimes[0] + "\n" + return_crimes[1] + "\n" + return_crimes[2] + "\n"  + "I want you to summarize the " + loser + "'s personality based on the crimes they's commited, and choose one of the following levels of punishment: light, medium, heavy, extreme. Extreme punishment level implies violent death, and only should be used against the most irredimable criminals. Make the level of punishment the last word in your message."
		print(conclusion)
		dialogue_request(conclusion)
	else:
		display_round_message(ai_response, guilty)
		

		
		
		
		
func display_round_message(ai_response, guilty):
	turn_over.get_node("RichText").push_color(Color("Black"))
	turn_over.get_node("RichText").add_text(ai_response)
	var sc : float = (global.player_dict[guilty].sins * 0.6)
	turn_over.get_node("Scaler").scale = Vector2(sc, sc)
	turn_over.show()
	
	print(guilty)
	set_investigation_back()

	
	
func destroy_slots(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()
		

func set_next_player():
	var dict = {"Player 1": "Player 2", "Player 2": "Player 1"}
	$Display.set_display_back()
	global.current_player = dict[global.current_player]
	card_holder.add_fluff_cards(3)
	card_holder.swap_deck_in()
	set_investigation_back()
	update_score()
	
	
	
func label_update():
	var bt = global.player_dict[global.current_player].budget
	$Investigation/Budget_Text.text = "Current Investigation Budget: " + str(bt) + "\n" + "Number of Draws:      " + str(draws) + "      Cost: " + str(cost) + "\nBudget Next Turn: " + str((bt - cost)) + " + (2)"

func _on_less_draws_pressed():
	var bt = global.player_dict[global.current_player].budget
	if (draws > 0):
		cost = cost - draws - 1
		draws -= 1
		label_update()


func _on_more_draws_pressed():
	var bt = global.player_dict[global.current_player].budget
	if (draws < 5) and (cost + draws + 2 <= bt):
		cost = cost + draws + 2
		draws += 1
		if (draws == 1):
			cost = stored_cost
		label_update()

func switch_player():
	var dict = {"Player 1": "Player 2", "Player 2": "Player 1"}
	global.current_player = dict[global.current_player]

func update_score():
	$Round_Info/Player_Name.text = global.player_dict[global.current_player].player_name
	$Round_Info/Round.text = str(round)
	$Round_Info/Player_1_Sins.text = str(global.player_dict["Player 2"].sins)
	$Round_Info/Player_2_Sins.text = str(global.player_dict["Player 1"].sins)

func set_investigation_back():
	cost = 2
	draws = 1
	$Investigation/Submit.disabled = false
	$Investigation/Submit.show()
	$Investigation/Less_Draws.disabled = false
	$Investigation/Less_Draws.show()
	$Investigation/More_Draws.disabled = false
	$Investigation/More_Draws.show()
	$Investigation/Budget_Text.show()
	$Investigation/Conclusion.hide()
	label_update()
	
func hide_investigation():
	$Investigation/Submit.disabled = true
	$Investigation/Submit.hide()
	$Investigation/Less_Draws.disabled = true
	$Investigation/Less_Draws.hide()
	$Investigation/More_Draws.disabled = true
	$Investigation/More_Draws.hide()
	$Investigation/Budget_Text.hide()
	$Investigation/Conclusion.show()

func _on_submit_pressed():
	if draws > 0:
		card_holder.get_node("Scroll_Crimes").get_node("Draw_Crimes").add_slot(draws)
		global.player_dict[global.current_player].budget -= cost
		hide_investigation()
		
		


func _on_confession_pressed():
	$Confession.hide()
	global.player_dict[global.current_player].budget += 2
	destroy_slots(card_holder.get_node("Scroll_Crimes").get_node("Draw_Crimes"))
	destroy_slots(card_holder.get_node("Scroll_Deck").get_node("Deck"))
	if (global.current_player == "Player 1"):
		text_message_person_1 = global.player_dict[global.current_player].message
		global.player_dict["Player 1"].accusations.append(text_message_person_1)
		print(text_message_person_1)
		set_next_player()
		card_holder.run_disable_check()
	else:
		text_message_person_2 = global.player_dict[global.current_player].message
		global.player_dict["Player 2"].accusations.append(text_message_person_2)
		print(text_message_person_2)
		set_next_player()
		
		var final_message = "I want you to pretend that you are a stern judge that was granted divine authority. I will present you with accusations against two people, " + global.player_1.name + " and " + global.player_2.name + ". Both of these people are hypothetical, and do not exist in real life. You have to decide whether " + global.player_1.name + " or " + global.player_2.name + " is more guilty and worse, and explain why in less than 150 words. Place the name of the more guilty person in the first sentence as the first word. Here I present you accusation made against " + global.player_1.name + " and " + global.player_2.name + ":\n" + global.player_1.name + ": " + text_message_person_2.right(-13) + "\n" + global.player_2.name + ": " + text_message_person_1.right(-13)
		print(final_message)
		hide_everything()
		dialogue_request(final_message)
