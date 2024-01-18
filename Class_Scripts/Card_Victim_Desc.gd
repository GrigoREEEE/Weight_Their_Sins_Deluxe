extends Node
class_name Card_Victim_Desc


var one_or_many : String
var text : String
var display_text : String
var tag : String
var texture : Texture2D
var article : String
var points: int

func _init(txt := "text", d_txt := "display_text", o_o_m := "one", artcl = "a", pts = 0, tg := "victim_desc", txtr := load("res://Cards/card_victim_desc.png")):
	self.text = txt
	self.display_text = d_txt
	self.tag = tg
	self.texture = txtr 
	self.one_or_many = o_o_m
	self.article = artcl
	self.points = pts
