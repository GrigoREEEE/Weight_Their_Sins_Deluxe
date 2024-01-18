extends Node2D


# card-related data
var is_dragging : bool = false
var current_player = "Player 1"
var card_in : bool = false


### Object lists
var crime_list : Array = []
var object_list : Array = []
var victim_list : Array = []
var crime_desc_list : Array = []
var victim_desc_list : Array = []

var desc_list : Array = []
var total_list : Array = []
var fluff : Array = []
var fluff_exclusions : Array = []
var crime_exclusions : Array = []

# Player Data
var player_1
var player_2
var player_dict : Dictionary = {"Player 1": [], "Player 2": []}

func _ready():
	player_1 = Player.new("Player 1")
	player_2 = Player.new("Player 2")
	player_dict["Player 1"] = player_1
	player_dict["Player 2"] = player_2
	var excel = ExcelFile.open_file("res://Cards_Crime.xlsx")
	var workbook = excel.get_workbook()
	var sheet = workbook.get_sheet(0)
	var table_data = sheet.get_table_data()
	var l = sheet.get_sheet_length(table_data)

	# Reading the crimes
	print(table_data)
	for row in range(2,l):
		var column_data = table_data[row]
		crime_list.append(Card_Crime.new(column_data[1],column_data[2],column_data[3],column_data[4]))

	
	# Reading the objects
	excel = ExcelFile.open_file("res://Cards_Object.xlsx")
	workbook = excel.get_workbook()
	sheet = workbook.get_sheet(0)
	table_data = sheet.get_table_data()
	l = sheet.get_sheet_length(table_data)
	for row in range(2,l):
		var column_data = table_data[row]
		object_list.append(Card_Object.new(column_data[1],column_data[2],column_data[3],column_data[4],column_data[5]))
	
	# Reading the victims
	excel = ExcelFile.open_file("res://Cards_Victim.xlsx")
	workbook = excel.get_workbook()
	sheet = workbook.get_sheet(0)
	table_data = sheet.get_table_data()
	l = sheet.get_sheet_length(table_data)
	for row in range(2,l):
		var column_data = table_data[row]
		victim_list.append(Card_Victim.new(column_data[1],column_data[2],column_data[3],column_data[4]))
	
	
	# Reading the crimes descriptions
	excel = ExcelFile.open_file("res://Cards_Crime_Desc.xlsx")
	workbook = excel.get_workbook()
	sheet = workbook.get_sheet(0)
	table_data = sheet.get_table_data()
	l = sheet.get_sheet_length(table_data)
	for row in range(2,l):
		var column_data = table_data[row]
		crime_desc_list.append(Card_Crime_Desc.new(column_data[1],column_data[2],column_data[3]))

	# Reading the victims descriptions
	excel = ExcelFile.open_file("res://Cards_Victim_Desc.xlsx")
	workbook = excel.get_workbook()
	sheet = workbook.get_sheet(0)
	table_data = sheet.get_table_data()
	l = sheet.get_sheet_length(table_data)
	for row in range(2,l):
		var column_data = table_data[row]
		victim_desc_list.append(Card_Victim_Desc.new(column_data[1],column_data[2],column_data[3],column_data[4]))
	
	desc_list = crime_desc_list + victim_desc_list
	total_list = crime_list + object_list + victim_list + crime_desc_list + victim_desc_list
	fluff = crime_desc_list + victim_desc_list + victim_list + object_list
