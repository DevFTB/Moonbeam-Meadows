extends Node2D

# Music files

@export_group("Music Files")
@export var music_files_loaded = 0
@export var music_1 : AudioStream
@export var music_2 : AudioStream
@export var music_3 : AudioStream
@export var music_4 : AudioStream
@export var music_5 : AudioStream

@export_group("Ambience Files")
@export var ambience_files_loaded = 0
@export var ambience_1 : AudioStream
@export var ambience_2 : AudioStream
@export var ambience_3 : AudioStream
@export var ambience_4 : AudioStream
@export var ambience_5 : AudioStream
@export_group("")

@export var music_player_volume = -8
@export var ambience_player_volume = -8

var current_music = null
var current_ambience = null


# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicPlayer.volume_db(music_player_volume)
	$MusicPlayer.bus("Music")
	
	$AmbiencePlayer.volume_db(ambience_player_volume)
	$AmbiencePlayer.bus("Ambient")
	pass # Replace with function body.

func play_music(sound):
	$MusicPlayer.set_stream(sound)
	$MusicPlayer.play(0)
	current_music = sound

func play_ambience(sound):
	$AmbiencePlayer.set_stream(sound)
	$AmbiencePlayer.play(0)
	current_ambience = sound

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

