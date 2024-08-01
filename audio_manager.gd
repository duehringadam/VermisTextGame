extends Node


func play_sound(stream: AudioStream):
	var instance = AudioStreamPlayer.new()
	instance.stream = stream
	instance.finished.connect(remove_node.bind(instance))
	add_child(instance)
	instance.pitch_scale = randf_range(0.8,1.2)
	instance.play()


func remove_node(instance: AudioStreamPlayer):
	instance.queue_free()

