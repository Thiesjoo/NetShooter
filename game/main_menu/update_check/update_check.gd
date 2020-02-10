extends Control

onready var animation_player := $AnimationPlayer as AnimationPlayer
onready var version_label := $Version as Label
onready var update_button := $UpdateDialog/VBoxContainer/Update as Button
onready var popup := $UpdateDialog
onready var http_request := $HTTPRequest as HTTPRequest

# Only update once every UPDATE_THROTTLE seconds at most
# The GitHub releases API only allows 60 unauthenticated requests per hour,
# so this value should be kept relatively high
const UPDATE_THROTTLE = 600

var manual = false


func _ready() -> void:
	version_label.text = "Version: "+ str(ProjectSettings.get("application/config/version"))

	# User preference overrides the setting defined on export
	if Settings.file.get_value("network", "check_for_updates", ProjectSettings.get("application/config/check_for_updates")):
		check_for_updates()



func check_for_updates() -> void:
	if OS.get_unix_time() < int(Settings.cache.get_value("updates", "last_check", 0)) + UPDATE_THROTTLE:
		print("INFO: Skipping update check since updates were recently checked.")
		if (manual):
			OS.alert("Updates where checked recently. We are not checking now to prevent server overload")
		return
	else:
		print("INFO: Checking for updates…")

	var error := http_request.request(
			"https://api.github.com/repos/{user}/{repository}/releases".format({
					user = ProjectSettings.get("application/config/github_user"),
					repository = ProjectSettings.get("application/config/github_repo"),
			})
	)

	if error != OK:
		push_error("A client error occurred while trying to check for updates.")


func _on_http_request_completed(result: int, _response_code: int, _headers: PoolStringArray, body: PoolByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		# The request failed for any reason, abort
		push_error("Couldn't check for updates due to a network error.")
		return
	else:
		print("INFO: Update check successful.")

	# Store timestamp of last successful update check (used for throttling)
	Settings.cache.set_value("updates", "last_check", OS.get_unix_time())
	Settings.save()

	var json = parse_json(body.get_string_from_utf8())
	var updated_tag = json[0].tag_name
	var updated_version = _parse_version_info(updated_tag)
	var current_version = _parse_version_info(ProjectSettings.get("application/config/version"))


	if current_version < updated_version:
		print("There is a new update")
		popup.popup()

		# Set the URL that will be opened when the button is pressed
		update_button.set_meta("url", json[0].html_url)
	elif (manual):
		OS.alert("No updates found")
	manual = false


func _on_update_pressed() -> void:
	var error := OS.shell_open(update_button.get_meta("url"))
	popup.hide()

	if error != OK:
		push_error("An error occurred while trying to open the Releases page in a Web browser.")


# Parses an ISO-8601 date string to a datetime dictionary that can be parsed by Godot.
func _parse_date(iso_date: String) -> Dictionary:
	var date := iso_date.split("T")[0].split("-")
	var time := iso_date.split("T")[1].trim_suffix("Z").split(":")

	return {
		year = date[0],
		month = date[1],
		day = date[2],
		hour = time[0],
		minute = time[1],
		second = time[2],
	}

func _parse_version_info(info):
	var return_value = info.trim_prefix("v")
	return_value = return_value.trim_suffix("-alpha")
	return_value = return_value.replace(".", "")
	return int(return_value)

func _on_CheckUpdate_pressed():
	manual = true
	check_for_updates()
