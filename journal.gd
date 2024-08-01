extends Resource

class_name Journal
@export var journal_name = ""
@export_multiline var journal_entry = ""


func return_journal_entry() -> String:
	return journal_entry

func return_journal_name() -> String:
	return journal_name
