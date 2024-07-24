extends Node

signal character_selected(character: Resource)
signal dialogue_ended
signal start_game


var select_bool 


func get_select_bool():
	return select_bool

func set_select_bool(select: bool):
	select_bool = select
