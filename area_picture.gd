extends TextureRect

var fadein = false

func _process(_delta: float) -> void:
	pass

func _on_command_processor_room_changed(new_room: Variant) -> void:
	if new_room.areaPicture != null:
		self.texture = new_room.areaPicture
		fadein = true
		

func _on_command_processor_npc_talk(npc: Variant) -> void:
	if npc.icon != null:
		self.texture = npc.icon
		fadein = true


func _on_combat_player_attack() -> void:
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("attack",2,false)


func _on_animated_sprite_2d_animation_finished() -> void:
	$AnimatedSprite2D.visible = false
