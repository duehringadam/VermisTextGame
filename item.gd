extends Resource
class_name Item

@export var itemName: String = "Item Name"
@export var itemType := Types.ItemTypes.KEY
@export_multiline var itemDescription: String = "Item Description"
@export var itemPicture: Texture2D
@export var isEquipped = false
var useValue = null

