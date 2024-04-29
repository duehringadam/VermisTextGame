extends Resource
class_name Item

@export var itemName: String = "Item Name"
@export var itemType := Types.ItemTypes.KEY
@export var itemDescription: String = "Item Description"
@export var itemPicture: Texture2D

func get_item_picture(item):
	return itemPicture

var useValue = null

