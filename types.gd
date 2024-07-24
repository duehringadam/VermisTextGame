extends Node

@onready var itemPicDic = {"key":load("res://items/item_pictures/item_key_01.png"),
"Sword":load("res://items/item_pictures/Whistling_death.png"),
"Skull":load("res://items/item_pictures/Skull.png"),
"battle-axe":load("res://items/item_pictures/Bone-Crusher.png")}

enum ItemTypes{
	KEY,
	QUEST,
	ARMOR,
	WEAPON,
	JEWELRY
}


