extends PanelContainer
@onready var itemList: Array = []

@onready var equippeditems1 = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Weapon
@onready var equippeditems2 = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Armor
@onready var equippeditems3 = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Jewelry
@onready var equippeditems4 = $MarginContainer/VBoxContainer/PanelContainer/HBoxContainer/Spell

@onready var itemPictureList: Array = [
$MarginContainer/VBoxContainer/inventory/PanelContainer/item1,
$MarginContainer/VBoxContainer/inventory/PanelContainer2/item2,
$MarginContainer/VBoxContainer/inventory/PanelContainer3/item3,
$MarginContainer/VBoxContainer/inventory/PanelContainer4/item4,
$MarginContainer/VBoxContainer/inventory/PanelContainer5/item5,
$MarginContainer/VBoxContainer/inventory/PanelContainer6/item6,
$MarginContainer/VBoxContainer/inventory/PanelContainer7/item7,
$MarginContainer/VBoxContainer/inventory/PanelContainer8/item8,
$MarginContainer/VBoxContainer/inventory/PanelContainer9/item9,
$MarginContainer/VBoxContainer/inventory/PanelContainer10/item10,
$MarginContainer/VBoxContainer/inventory/PanelContainer11/item11,
$MarginContainer/VBoxContainer/inventory/PanelContainer12/item12]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_command_processor_item_taken(item: Variant) -> void:
	#print("Starting Item Added!")
	itemList.append(item)
	if itemList.find(item):
		itemPictureList[itemList.find(item.itemName)].texture = null
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
	else:
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
		#print(Types.itemPicDic[itemList[loop]])
		itemPictureList[loop].texture = Types.itemPicDic[itemList[loop]]
		loop+=1
		
	while loop != 11:
		itemPictureList[loop].texture = null
		loop +=1
	

func _on_command_processor_item_unequipped(item: Variant) -> void:
	match item.itemType:
		Types.ItemTypes.WEAPON:
			equippeditems1.text = ""
		Types.ItemTypes.ARMOR:
			equippeditems2.text = ""
		Types.ItemTypes.JEWELRY:
			equippeditems3.text = ""
		Types.ItemTypes.SPELL:
			equippeditems4.text = ""
		
	


func _on_player_item_equipped(equipped_items: Variant) -> void:
	match equipped_items.itemType:
		Types.ItemTypes.WEAPON:
			equippeditems1.text = equipped_items.itemName 
		Types.ItemTypes.ARMOR:
			equippeditems2.text = equipped_items.itemName 
		Types.ItemTypes.JEWELRY:
			equippeditems3.text = equipped_items.itemName
		Types.ItemTypes.SPELL:
			equippeditems4.text = equipped_items.itemName

