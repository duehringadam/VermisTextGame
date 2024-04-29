extends Node

var damage = 1
var inventory: Array = []
var inventoryMax = 12
var inventoryHeld = 0
var health = 1
var player_dead := false


func takeItem(item: Item):
	if inventoryHeld < inventoryMax:
		inventory.append(item)
		inventoryHeld += 1
	elif inventoryHeld >= inventoryMax:
		return "You cannot carry anymore!"
	
func dropItem(item: Item):
	inventory.erase(item)
	
func getInventory() -> String:
	if inventory.size() == 0:
		return "Your inventory is empty!"
	
	var itemString = ""
	for item in inventory:
		itemString += item.itemName + " "
	return "Inventory: " + itemString

