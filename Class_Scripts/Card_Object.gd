extends Node
class_name Card_Object

var article : String
var several_objects : bool
var alive : bool
var text : String
var display_text : String
var tag : String
var texture : Texture2D
var points: int


func _init(txt := "text", d_txt := "display_text", artcl := "a", alv := false, pts = 0, tg := "object", txtr := load("res://Cards/card_object.png")):
	self.text = txt
	self.display_text = d_txt
	self.tag = tg
	self.texture = txtr 
	self.article = artcl
	self.alive = alv
	self.points = pts
