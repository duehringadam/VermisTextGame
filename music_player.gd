extends Node


@export var track: Music

var song_name = ""

signal music_changed

func change_song():
	song_name = track.name
	var audio_stream = load(track.file_path)
	music_changed.emit()
	
func play_music():
	$audio_player.stream = track
	$audio_player.play()
