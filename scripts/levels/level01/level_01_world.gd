extends Node2D

const level_music = preload("res://audio/music/level01-music.mp3")
const boss_music = preload("res://audio/music/final_boss_music_level_01.mp3")

@onready var player: CharacterBody2D = $Player
@onready var level_01_music_player: AudioStreamPlayer = %Level01MusicPlayer



func _init() -> void:
	GlobalSignals.connect(Consts.S_PLAY_FINAL_LEVEL01_AUDIO, fade_level_audio)
	GlobalSignals.connect(Consts.S_PLAY_LEVEL01_AUDIO, fade_boss_audio)

func _ready() -> void:
	Vars.player_points = Vars.player_points_initial_value
	#player.position = Vars.player_position
	var interface = preload("res://scenes/ui/interface.tscn").instantiate()
	add_child(interface)

func fade_level_audio() -> void:
	AudioUtil.fade_out_audio(level_01_music_player, play_boss_audio, -60, 3)

func play_boss_audio() -> void:
	AudioUtil.load_sfx(level_01_music_player, boss_music)
	level_01_music_player.play()
	level_01_music_player.volume_db = 0

func fade_boss_audio() -> void: 
	AudioUtil.fade_out_audio(level_01_music_player, play_level_music, -60, 3)

func play_level_music() -> void:
	AudioUtil.load_sfx(level_01_music_player, level_music)
	level_01_music_player.play()
	level_01_music_player.volume_db = 0
