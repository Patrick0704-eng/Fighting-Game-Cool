extends AudioStreamPlayer
const level_music = preload("res://assets/voicelines/Street Fighter 2 - Menu Theme Music  GAMER CAGOULER.mp3")

func _play_music(music:AudioStream, volume = 0.0):
	if stream  == level_music:
		return
	stream = music
	volume_db = volume
	play()
	
func _play_music_level():
	_play_music(level_music)
func play_FX(stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "fx_player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	fx_player.queue_free()
