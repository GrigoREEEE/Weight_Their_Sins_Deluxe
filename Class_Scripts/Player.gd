extends Node
class_name Player

var player_name : String
var message : String
var pronoun : Array
var deck : Array
var sins : int
var budget : int
var accusations : Array
var guilt : Array


func _init(pn := "Huy", pr := ["He", "Him", "His"], s = 0, b := 20, m = ""):
	self.player_name = pn
	self.pronoun = pr
	self.sins = s
	self.budget = b
	self.message = m
	self.deck = []
	self.accusations = []
	self.guilt = []
