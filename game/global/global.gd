extends Node

var games = [{
	"name": "TEST PREGEN", 
	"thumbnail": null,
	"created_at": OS.get_unix_time(),
	"last_modified": OS.get_unix_time(),
	"map_seed": 0, 
	"map_traits": {"ya_teer": 123},
	"player": {"skin": 1, "XP": 123},
	"stage": 1,
	"inventory": {},
	"explored_chunks": []}]
export var game_data = {}
export var inventory_data = {}
export var current_game_id = NAN

func _ready():
	randomize()
	self.set_pause_mode(2)
	print("User save dir: ", OS.get_user_data_dir())
	print("Global game script has started")
	load_game_from_file()

func exit():
	save_game_to_file()
	print("Exitting game")
	get_tree().quit()

func load_game_from_file():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		
	games = []
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if typeof(current_line) == TYPE_DICTIONARY:
			print("loaded game: ", current_line)
			games.push_front(current_line)
		else:
			print("Corrupt line")
	sort_games()

func save_game_to_file():
	Settings.save()
	print("Saving user data")
	
	print("Saving map")
	save_game()

	var save_game_file = File.new()
	save_game_file.open("user://savegame.save", File.WRITE)
	for game in games:
		print("Saving game: ", game)
		save_game_file.store_line(to_json(game))
	save_game_file.close()

func load_game(id):
	if (games[id]):
		current_game_id = id
		game_data = games[id]
		print("Loaded save game data: ", game_data)

func save_game_and_exit(scene):
	if (game_data):
		save_game()
		game_data = {}
		current_game_id = NAN
		Scene_loader.switch_scene(scene)

func save_game():
	if (game_data):
		game_data.last_modified = OS.get_unix_time()
		games.remove(current_game_id)
		games.push_front(game_data)

func new_game():
	game_data = {
	"name": "", 
		"thumbnail": null,
	"created_at": OS.get_unix_time(),
	"last_modified": OS.get_unix_time(),
	"map_seed": randi(), 
	"map_traits": {"ya_teer": 123},
	"player": {"skin": 1, "XP": 123},
	"stage": 1,
	"inventory": {},
	"explored_chunks": []}

func sort_games():
	print(games)
	games.sort_custom(self, "_sort_games_date")
	print(games)

func _sort_games_date(a,b):
	return a.last_modified > b.last_modified
