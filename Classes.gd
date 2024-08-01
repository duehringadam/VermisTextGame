extends Resource

class_name starting_Class
@export var player_stats = {
	"Name": "",
	"Health": 1,
	"Max Health": 1,
	"Strength": 0,
	"Intelligence": 0,
	"Faith": 0,
	"Will": 0,
	"Damage": 1
}

@export_multiline var description = ""

@export var starting_items: = {
	"Item 1": Object, 
	"Item 2": Object
	}

@export var icon: Texture2D

@export var journal: Array[Journal] = []
