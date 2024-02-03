extends PanelContainer

@onready var roomName = $"MarginContainer/Rows/RoomNameLabel"
@onready var roomDescription = $"MarginContainer/Rows/roomDescription"
@onready var exitlabel = $"MarginContainer/Rows/exitLabel"
@onready var npcLabel = $"MarginContainer/Rows/npcsLabel"
@onready var itemLabel = $"MarginContainer/Rows/itemLabel"

func handle_room_changed(new_room):
	roomName.text = new_room.roomName
	roomDescription.text = new_room.roomDescription
	exitlabel.text = new_room.getRoomExit()
	npcLabel.text = new_room.getNPCDescription()
	itemLabel.text = new_room.getItemDescription()
