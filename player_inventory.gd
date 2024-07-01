extends PanelContainer
@onready var itemList: Array = []

@onready var itemPictureList: Array = [$"MarginContainer/inventory/item1",
$"MarginContainer/inventory/item2",
$"MarginContainer/inventory/item3",
$"MarginContainer/inventory/item4",
$"MarginContainer/inventory/item5",
$"MarginContainer/inventory/item6",
$"MarginContainer/inventory/item7",
$"MarginContainer/inventory/item8",
$"MarginContainer/inventory/item9",
$"MarginContainer/inventory/item10",
$"MarginContainer/inventory/item11",
$"MarginContainer/inventory/item12"]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_command_processor_item_taken(item: Variant) -> void:
	itemList.append(item)
	var trigger = false
	var itemIterate = 0
	while !trigger:
		if itemPictureList[itemIterate].texture == null:
			itemPictureList[itemIterate].texture = item.itemPicture
			itemList[itemIterate] = item.itemName
			#print(itemList)
			trigger = true
		else:
			itemIterate += 1


func _on_command_processor_item_dropped(item: Variant) -> void:
	itemPictureList[itemList.find(item.itemName)].texture = null
	itemList.erase(item.itemName)
	
	#print(itemList[0])
	var count = itemList.size()
	var loop = 0
	
	while loop != count:
		print(Types.itemPicDic[itemList[loop]])
		itemPictureList[loop].texture = Types.itemPicDic[itemList[loop]]
		loop+=1
		
	while loop != 11:
		itemPictureList[loop].texture = null
		loop +=1
	
