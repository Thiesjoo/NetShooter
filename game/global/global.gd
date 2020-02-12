extends Node

var games = []
var game_data: Savegame
var current_game_id: int = NAN

func _ready():
	randomize()
	self.set_pause_mode(2)
	print("User save dir: ", OS.get_user_data_dir())
	print("Global game script has started")
	load_games_from_file()

func exit():
	save_game_to_file()
	print("Exitting game")
	get_tree().quit()

func load_games_from_file():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("First boot. Save file not here")
		return # Error! We don't have a save to load.
		
	games = []
	save_game.open("user://savegame.save", File.READ)
	while not save_game.eof_reached():
		var current_line = parse_json(save_game.get_line())
		if typeof(current_line) == TYPE_DICTIONARY:
			var save = Savegame.new()
			save.from_json(current_line)
			games.append(save)
		else:
			print("Corrupt line")
	sort_games()

func save_game_to_file():
	Settings.save()
	var save_game_file = File.new()
	save_game_file.open("user://savegame.save", File.WRITE)
	for game in games:
		print("Saving game: ", game)
		save_game_file.store_line(to_json(game.json()))
	save_game_file.close()
	print("Saved data to file")

func load_game(id):
	if (games[id]):
		current_game_id = id
		game_data = games[id]

func save_game_and_exit(scene):
	if (game_data):
		save_game()
		game_data = null
		current_game_id = NAN
		Scene_loader.switch_scene(scene)

func save_game():
	if (game_data):
		game_data.last_modified = OS.get_unix_time()
		game_data.player.position = get_node("../Game/Level/Game/Player").position
		#TODO: Gather all data
		games.remove(current_game_id)
		games.push_front(game_data)

func new_game():
	game_data = Savegame.new()

func sort_games():
	games.sort_custom(self, "_sort_games_date")

func _sort_games_date(a,b):
	return a.last_modified > b.last_modified
