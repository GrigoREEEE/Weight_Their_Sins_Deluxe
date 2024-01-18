extends TextureRect


@onready var parent = get_tree().get_root().get_node("Main/Card_Holder")

#var display_text_path = preload("res://display_text.tscn")
var card_preview_path = preload("res://Preview_card.tscn")
var is_occupied : bool = false
var blocked : bool = false
#var slot_state_data : Dictionary = {"blocked": false, is_occupied: false}
var card

	
func add_rich_text():
	$Label.text = card.display_text
	

func empty_slot(slot):
	slot.card = null
	slot.texture = null
	slot.find_child("Label").text = ""
	#slot_state_data["blocked"] = false
	#slot_state_data["is_occupied"] = false
	is_occupied = false

func _get_drag_data(at_position):
	if (!self.blocked):
		print("Picked Up!")
		parent.is_being_dragged = true
		
		var preview_texture = card_preview_path.instantiate()
		preview_texture.z_index = 20
		preview_texture.texture = self.texture
		preview_texture.get_node("Label").text = card.display_text
		preview_texture.expand_mode = 1
		preview_texture.size = Vector2(120,60)

		var preview = Control.new()
		preview.add_child(preview_texture)
		set_drag_preview(preview)
		
		parent.all_data = {"card": self.card, "previous_point": self}
		empty_slot(self)
		
		return parent.all_data
	
func _can_drop_data(_pos, data):
	return data is Dictionary
	
func _drop_data(_pos, data):
	print("Data Dropped")
	if (!self.blocked):
		if (self.name == "Card_Acceptor"):
			get_tree().get_root().get_node("Main/Game_Manager/Display").place_card_on_display(data)
			#data["previous_point"].remove_child()
			#data["previous_point"].queue_free()
		else:
			if (self.texture != null):
				parent.assign_card(data["previous_point"],self.card)
				self.find_child("Label").text = ""
			parent.assign_card(self,data["card"])
		
		parent.is_being_dragged = false
		parent.all_data = {"card": null, "previous_point": null}
	
		parent.sort_cards()

