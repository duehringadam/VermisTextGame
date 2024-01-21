extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var key = Item.new()
	var poopBucket = Item.new()
	
	poopBucket.initialize("A Poop Bucket", Types.ItemTypes.KEY)
	key.initialize("Key", Types.ItemTypes.KEY)
	
	
	$Field.connectExit("north", $Field2)
	$Field2.connectExit("west",$Field3)
	
	$Field3.addItem(poopBucket)
	$Field.addItem(key)

