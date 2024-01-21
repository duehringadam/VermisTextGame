extends Resource
class_name Item

@export var itemName: String = "Item Name"
@export var itemType := Types.ItemTypes.KEY


func initialize(itemName: String, itemType: Types.ItemTypes):
	self.itemName = itemName
	self.itemType = itemType
