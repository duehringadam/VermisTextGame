extends Node

var inventory: Array = []

func takeItem(item: Item):
	inventory.append(item)
	
func dropItem(item: Item):
	inventory.erase(item)
	
func getInventory() -> String:
	if inventory.size() == 0:
		return "Your inventory is empty!"
	
	var itemString = ""
	for item in inventory:
		itemString += item.itemName + " "
	return "Iventory: " + itemString
