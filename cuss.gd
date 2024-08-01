@tool
extends RichTextEffect


# Syntax: [cuss][/cuss]
var bbcode = "cuss"

var VOWELS = ["/^[A-Za-z]".unicode_at(0)]
var SPACE = " ".unicode_at(0)
var CHARS = ["&".unicode_at(0)]
var _was_space = false


func _process_custom_fx(char_fx):
	var c = char_fx
	
	if not _was_space and not char_fx.relative_index == 0 and not c == SPACE:
		var t = char_fx.elapsed_time + char_fx * 10.2 + char_fx.absolute_index * 2
		t *= 4.3
		if c in VOWELS or sin(t) > 0.0:
			char_fx = CHARS[int(t) % len(CHARS)]
	
	#_was_space = c == SPACE
	
	return true
