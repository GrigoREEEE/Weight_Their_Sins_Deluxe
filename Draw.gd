extends VBoxContainer

var slot_path = preload("res://Card.tscn")

func add_slot(numbers):
	for i in numbers:
		var index
		var slot = slot_path.instantiate()
		slot.add_to_group("Crimes")
		self.add_child(slot)
		while(true):
			index = randi() % global.crime_list.size()
			if (!(index in global.crime_exclusions)):
				global.crime_exclusions.append(index)
				break
		var item = global.crime_list[index]
		print(item.target)
		get_tree().get_root().get_node("Main/Card_Holder").assign_card(slot, item)
		get_tree().get_root().get_node("Main/Card_Holder").assign_card_tooltip(slot)



