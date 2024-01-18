extends Node
class_name Card_Victim


var group : bool
var article : String
var text : String
var display_text : String
var tag : String
var texture : Texture2D
var points: int

func _init(txt := "text", d_txt := "display_text", grp := false, art := "a", pts = 0, tg := "victim", txtr := load("res://Cards/card_victim.png")):
	self.text = txt
	self.display_text = d_txt
	self.tag = tg
	self.texture = txtr 
	self.group = grp
	self.article = art
	self.points = pts
