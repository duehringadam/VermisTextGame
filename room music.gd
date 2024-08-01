extends AudioStreamPlayer

var storedMusic
var fading = false


func _process(delta: float) -> void:
	if fading:
		volume_db += 30*delta
		if volume_db >=0:
			fading = false
		

func storeMusic(music):
	storedMusic = music
	print(storedMusic)

func change_music(new_room):
	if new_room != null && new_room.music != null && storedMusic != new_room.music:
		self.stream = new_room.music
		self.play()
		storeMusic(new_room.music)
		

func battle_music(musicstream):
	if musicstream != null:
		self.stream = musicstream
		self.play()

func reset_music():
	self.stream = storedMusic
	self.play()

func death_music(music):
	print("test")
	self.stream = music
	self.play()

