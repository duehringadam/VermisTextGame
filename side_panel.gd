extends PanelContainer

@onready var player = $"../../../../../../../../Player"
@onready var roomName = $"MarginContainer/ScrollContainer/Rows/RoomNameLabel"
@onready var roomDescription = $"MarginContainer/ScrollContainer/Rows/roomDescription"
@onready var exitlabel = $"MarginContainer/ScrollContainer/Rows/exitLabel"
@onready var npcLabel = $"MarginContainer/ScrollContainer/Rows/npcsLabel"
@onready var itemLabel = $"MarginContainer/ScrollContainer/Rows/itemLabel"
@onready var scroll = $MarginContainer/ScrollContainer
@onready var scrollbar = scroll.get_v_scroll_bar()
@onready var commandProcessor = $"../../../../../../../../CommandProcessor"

func _ready() ->void:
	scrollbar.connect("changed", _handle_scrollbar_changed)
	
func _process(delta: float) -> void:
	if player.status_effects["Blindness"] == true:
		roomName.text = "You cannot see."
		roomDescription.text = ""
		exitlabel.text = ""
		npcLabel.text = ""
		itemLabel.text = ""
	elif player.status_effects["Blindness"] == false && commandProcessor.current_room != null:
		handle_room_changed(commandProcessor.current_room)
	
func handle_room_changed(new_room):
	if player.status_effects["Blindness"] == true:
		roomName.text = "You cannot see."
		roomDescription.text = ""
		exitlabel.text = ""
		npcLabel.text = ""
		itemLabel.text = ""
	else:
		roomName.text = new_room.roomName
		roomDescription.text = new_room.roomDescription
		exitlabel.text = new_room.getRoomExit()
		npcLabel.text = new_room.getNPCDescription()
		itemLabel.text = new_room.getItemDescription()
	

func _handle_scrollbar_changed():
	scroll.scroll_vertical = scrollbar.max_value
