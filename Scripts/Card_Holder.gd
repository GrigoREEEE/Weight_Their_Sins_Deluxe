extends Node2D

var card_path = preload("res://Card.tscn")
var is_being_dragged : bool = false
var all_data : Dictionary = {"card": null, "previous_point": null}
@onready var display : Node = get_tree().get_root().get_node("Main/Game_Manager/Display")

func _ready():
	add_fluff_cards(3)
	fluff_to_hand()
	run_disable_check()
	
#Returns an array of size 'size', that contains r.g.n. between 
# 0 and length of the 'array' array.
func generate_draw_indicies(size,array):
	var draw_indicies = []
	var l = len(array)
	var i = 0
	while i < size:
		var index = randi_range(0, l-1)
		if !(index in global.fluff_exclusions):
			draw_indicies.append(index)
			global.fluff_exclusions.append(index)
			i += 1
	return draw_indicies
	
#Modifies the current player's hand by adding 'size' number of non-crime cards
# to their hand.
func add_fluff_cards(size):
	var deck = global.player_dict[global.current_player].deck
	if ((deck.size() + size) >= 10):
		size = 10 - deck.size()
	
	if (size > 0):
		var indicies = generate_draw_indicies(size,global.fluff)
		print(indicies)
		for i in indicies:
			print(indicies)
			deck.append(global.fluff[i])

# Creates a slot and assigns a 'card' Card to it, then returns it.
func create_card(card):
	var slot = card_path.instantiate()
	assign_card(slot,card)
	assign_card_tooltip(slot)
	return slot

#Takes cards from the current player's hand and places them onto display.
func fluff_to_hand():
	var cur = 0
	var deck = global.player_dict[global.current_player].deck
	for _i in deck:
		var card = create_card(_i)
		$Scroll_Deck/Deck.add_child(card)
		
		
#Assigns the card to a slot.
func assign_card(slot, card):
	slot.is_occupied = true
	slot.texture = card.texture
	slot.card = card
	slot.add_rich_text()
	
#Adds a cards from the 'cards' Array back to hand.
func add_cards_back(cards):
	print(cards)
	for _k in cards:
		var card = create_card(_k)
		
		if (_k.tag in ["object", "victim", "victim_desc", "crime_desc"]):
			$Scroll_Deck/Deck.add_child(card)
		else:
			$Scroll_Crimes/Draw_crimes.add_child(card)

#Empties all cards in the 'group' String.
func purge_box(group):
	for _i in get_tree().get_nodes_in_group(group):
		_i.empty_slot(_i)
		_i.queue_free()

#Check every card current player has, disables it if it cannot be
# dragged into the display
func run_disable_check():
	for _n in $Scroll_Deck/Deck.get_children():
		if !(_n.card.tag in display.allowed_tags):
			_n.get_node("Darken").show()
			_n.blocked = true
		else:
			_n.get_node("Darken").hide()
			_n.blocked = false
	for _n in $Scroll_Crimes/Draw_Crimes.get_children():
		if !(_n.card.tag in display.allowed_tags):
			_n.get_node("Darken").show()
			_n.blocked = true
		else:
			_n.get_node("Darken").hide()
			_n.blocked = false

func assign_card_tooltip(slot):
	var type = slot.get_node("Type")
	if slot.card.tag == "crime" and slot.card.target == "both":
		type.tooltip_text = "This Card contains info about the Crime that targets Objects or People."
	elif slot.card.tag == "crime" and slot.card.target == "person":
		type.tooltip_text = "This Card contains info about the Crime that targets People only."
	elif slot.card.tag == "crime" and slot.card.target == "property":
		type.tooltip_text = "This Card contains info about the Crime targets Objects only."
	elif slot.card.tag == "object":
		type.tooltip_text = "This Card contains info about the Object involed in the Crime."
	elif slot.card.tag == "victim":
		type.tooltip_text = "This Card contains info about the Victim of the Crime."
	elif slot.card.tag == "victim_desc":
		type.tooltip_text = "This Card contains descriptions of Victim of the Crime."
	elif slot.card.tag == "crime_desc":
		type.tooltip_text = "This Card contains descriptions of how the Crime was Commited."
	
		
		
#Sorts cards. Honestly, not sure how it works
func sort_cards():
	var found_empty = false
	var empty_index = null
	for _i in get_tree().get_nodes_in_group("Cards P1"):
		if (_i.is_occupied == false):
			if (_i.get_index() == $Scroll_Deck/Deck.get_child_count()):
				break
			elif (!found_empty):
				empty_index = _i.get_index()
				found_empty = true
		elif (found_empty):
			print("set " + str(_i) + " at position " + str(empty_index))
			$Scroll_Deck/Deck.move_child(_i, empty_index)
			sort_cards()
			break
	found_empty = false
	empty_index = null
	for _i in get_tree().get_nodes_in_group("Crimes"):
		if (_i.is_occupied == false):
			if (_i.get_index() == $Scroll_Crimes/Draw_Crimes.get_child_count()):
				break
			elif (!found_empty):
				empty_index = _i.get_index()
				found_empty = true
		elif (found_empty):
			print("set " + str(_i) + " at position " + str(empty_index))
			$Scroll_Crimes/Draw_Crimes.move_child(_i, empty_index)
			sort_cards()
			break

# Monitors when any cards are being dragged, and starts a timer when a card is placed
func _input(event):
	if (Input.is_action_just_released("click") and is_being_dragged):
		$Timer.start()
		
# Puts 
func _on_timer_timeout():
	
	if (is_being_dragged == true):
		assign_card(all_data["previous_point"],all_data["card"])
		
	is_being_dragged = false
	all_data = {"card": null, "previous_point": null}

func swap_deck_in():
	purge_box("Cards P1")
	purge_box("Crimes")
	fluff_to_hand()


