extends PanelContainer

@onready var item1 = $"MarginContainer/inventory/item1"
@onready var item2 = $"MarginContainer/inventory/item2"
@onready var item3 = $"MarginContainer/inventory/item3"
@onready var item4 = $"MarginContainer/inventory/item4"
@onready var item5 = $"MarginContainer/inventory/item5"
@onready var item6 = $"MarginContainer/inventory/item6"
@onready var item7 = $"MarginContainer/inventory/item7"
@onready var item8 = $"MarginContainer/inventory/item8"
@onready var item9 = $"MarginContainer/inventory/item9"
@onready var item10 = $"MarginContainer/inventory/item10"
@onready var item11 = $"MarginContainer/inventory/item11"
@onready var item12 = $"MarginContainer/inventory/item12"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func handle_iventory_changed(item):
	item1.texture = item.get_item_picture()
	
