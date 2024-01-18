extends Node
class_name Card_Crime_Desc


var comma : bool
var text : String
var display_text : String
var tag : String
var texture : Texture2D
var points: int

func _init(txt := "text", d_txt := "display_text", com := false, pts = 0, tg := "crime_desc", txtr := load("res://Cards/card_crime_desc.png")):
	self.text = txt
	self.display_text = d_txt
	self.tag = tg
	self.texture = txtr 
	self.comma = com
	self.points = pts
