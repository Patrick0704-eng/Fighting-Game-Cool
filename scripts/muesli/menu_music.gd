extends AudioStreamPlayer
const level_music = preload("res://assets/voicelines/Street Fighter II Ryu Theme Original.mp3")

func _play_music(music:AudioStream, volume = 0.0):
	if stream  == music:
		return
	stream = music
	volume_db = volume
	play()
	
func _play_music_level():
	_play_music(level_music)
