extends Node
class_name Card_Crime


var one_or_many : String
var target : String
var text : String
var display_text : String
var tag : String
var texture : Texture2D
var points: int

func _init(txt := "text", d_txt := "display_text", one_or_many := "one", target := "property", pts = 0, tg := "crime"):
	self.text = txt
	self.display_text = d_txt
	self.tag = tg
	self.one_or_many = one_or_many
	self.target = target
	self.points = pts
	if (self.target == "person"):
		self.texture = load("res://Cards/card_victim_crime.png")
	elif (self.target  == "property"):
		self.texture = load("res://Cards/card_object_crime.png")
	else:
		self.texture = load("res://Cards/card_crime.png")
		
