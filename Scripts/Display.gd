extends RichTextLabel

@onready var card_holder : Node = get_tree().get_root().get_node("Main/Card_Holder")
@onready var ui : Node = get_tree().get_root().get_node("Main/Interface/UI")


var accusation_dict : Dictionary = {"crime": [""], "victim": ["random person"], "crime_desc": [""], "victim_desc" : ["",""], "object": ["an object of value"]}
var allowed_tags : Array = ["crime"]
var victim_article : String = "a"
var victim_present : bool = false
var victim_described : bool = false
var crime_described : bool = false
var crime_described_with_comma : bool = false
var is_against_object : bool = false
var object_placed : bool = false;
var victim_description_count : int = 0
var crime_description_count : int = 0


func more_text():
	self.clear()
	self.push_color(Color("GREEN"))
	self.append_text("[b]%s[/b]" % [global.player_dict[global.current_player].message])
	
func set_display_back():
	self.clear()
	accusation_dict = {"crime": [""], "victim": ["random person"], "crime_desc": [""], "victim_desc" : ["",""], "object": ["an object of value"]}
	allowed_tags = ["crime"]
	victim_article = "a"
	victim_present = false
	victim_described = false
	crime_described = false
	crime_described_with_comma = false
	is_against_object = false
	object_placed = false
	victim_description_count = 0
	crime_description_count = 0
	
func update_display():
	
	var dict = {"Player 1": "Player 2", "Player 2": "Player 1"}
	var result = "Your Honour, " + global.player_dict[global.current_player].pronoun[0]
	
	if (crime_described):
		if (crime_described_with_comma):
			result = result + accusation_dict["crime_desc"][0]
		else:
			result = result + " " + accusation_dict["crime_desc"][0]
			
	if (is_against_object):
		if (!object_placed):
			result = result + " " + accusation_dict["crime"][0] + " " + accusation_dict["object"][0] + " that belonged to "
		else:
			result = result + " " + accusation_dict["crime"][0]
	else:
		result = result + " " + accusation_dict["crime"][0]
	
	if (is_against_object and object_placed):
		result = result + " " + accusation_dict["object"][0] + " that belonged to "
		
	result = result + " " + victim_article + " "
	
	if (victim_described):
		for _i in accusation_dict["victim_desc"]:

			if (_i != ""):
				result = result + _i + " "
			
	result = result + accusation_dict["victim"][0] + "."
	global.player_dict[global.current_player].message = result
	
	print(result)
	more_text()
			
	

func place_card_on_display(data):
	var card = data["card"]
	if (card.tag in allowed_tags):
		get_tree().get_root().get_node("Main/Game_Manager/Confession").show()
		if (card.tag == "crime"):
			card_holder.get_node("Scroll_Crimes").get_node("Draw_Crimes").remove_child(data["previous_point"])
		else:
			card_holder.get_node("Scroll_Deck").get_node("Deck").remove_child(data["previous_point"])
		data["previous_point"].queue_free()
		for _i in global.player_dict[global.current_player].deck:
			if _i.text == card.text:
				global.player_dict[global.current_player].deck.erase(_i)
		ui.get_node("AnimationPlayer").play("Gear_Rotate")
		if (card.tag == "crime"):
			allowed_tags = ["victim", "crime_desc", "victim_desc"]
			if (card.target in ["property", "both"]):
				allowed_tags.append("object")
				if (card.target == "property"):
					is_against_object = true
			accusation_dict["crime"][0] = card.text
		elif (card.tag == "victim"):
			if (!victim_described):
				victim_article = card.article
			victim_present = true
			accusation_dict["victim"][0] = card.text
			allowed_tags.erase("victim")
		elif (card.tag == "object"):
			accusation_dict["object"][0] = (card.article + " " + card.text)
			is_against_object = true
			object_placed = true
			allowed_tags.erase("object")
		elif (card.tag == "victim_desc"):
			if (victim_description_count == 0):
				victim_article = card.article
				accusation_dict["victim_desc"][victim_description_count] = (card.text)
			if (victim_description_count == 1):
				accusation_dict["victim_desc"][victim_description_count] = "and " + (card.text)
			victim_description_count += 1
			victim_described = true
			if (victim_description_count >= 2):
				allowed_tags.erase("victim_desc")
		elif (card.tag == "crime_desc"):
			crime_described = true
			crime_described_with_comma = card.comma
			accusation_dict["crime_desc"][0] = card.text
			allowed_tags.erase("crime_desc")
		update_display()
		card_holder.run_disable_check()
		
				
	else:
		print("Invalid card!")
		print(card.tag)
		card_holder.add_cards_back([card])
