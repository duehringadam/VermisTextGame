extends Node

@onready var itemPicDic = {"key":load("res://items/item_pictures/item_key_01.png"),
"Whistling Death":load("res://items/item_pictures/Whistling_death.png"),
"Skull":load("res://items/item_pictures/Skull.png"),
"battle axe":load("res://items/item_pictures/Bone-Crusher.png"),
"Armor": load("res://items/item_pictures/Exiled Sentinel Armor.png"),
"Stone Staff": load("res://items/item_pictures/Stone Staff(1).png"),
"Vertebra Stone":load("res://items/item_pictures/Vertebra Stone(1).png"),
"Bone Dagger": load("res://items/item_pictures/Bone Dagger.png"),
"Beloved Necklace": load("res://items/item_pictures/Beloved Necklace.png"),
"Murk Sling": load("res://items/Spells/Murk Sling.png"),
"Beast Eye": load("res://items/item_pictures/Beast Eye.png"),
"Beast Tongue": load("res://items/item_pictures/Beast Tongue.png"),
"Bone Fermenter": load("res://items/item_pictures/Bone Fermenter.png"),
"Broken Badge": load("res://items/item_pictures/Broken Badge.png"),
"Devotion Symbol": load("res://items/item_pictures/Devotion Symbol.png"),
"Ghylak's Visage": load("res://items/item_pictures/Ghylak's Visage.png"),
"Incense Bag": load("res://items/item_pictures/Incense Bag.png"),
"Iron Handcuffs": load("res://items/item_pictures/Iron Handcuffs.png"),
"Marko Effigy": load("res://items/item_pictures/Marko Effigy.png"),
"Moon Murder": load("res://items/item_pictures/Moon Murder.png"),
"Mother Doll": load("res://items/item_pictures/Mother Doll.png"),
"Sage Disciple": load("res://items/item_pictures/Sage Disciple.png"),
"Scented Oil": load("res://items/item_pictures/Scented Oil.png"),
"Snake Fang": load("res://items/item_pictures/Snake Fang.png"),
"Strength Gauntlets": load("res://items/item_pictures/Strength Gauntlets.png"),
"Whispering Stone": load("res://items/item_pictures/whispering stone.png"),
"Wicker Basket": load("res://items/item_pictures/Wicker Basket.png"),
"Witch Tongue": load("res://items/item_pictures/Witch Tongue.png"),
"Thousand Eyes": load("res://items/item_pictures/Thousand Eyes.png"),
"Mushroom": load("res://items/item_pictures/Mushroom.png")
}

enum ItemTypes{
	KEY,
	QUEST,
	ARMOR,
	WEAPON,
	JEWELRY,
	CONSUMABLE,
	SPELL
}


