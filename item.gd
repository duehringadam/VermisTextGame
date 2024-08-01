extends Resource
class_name Item

@export var itemName: String = "Item Name"
@export var itemType := Types.ItemTypes.KEY
@export_multiline var itemDescription: String = "Item Description"
@export var itemPicture: Texture2D = load("res://items/item_pictures/Vertebra Stone(1).png")
@export var isEquipped = false
@export var required_Stats: Dictionary = {"Strength": 0, "Intelligence": 0, "Faith": 0, "Will":0}
var useValue = null

