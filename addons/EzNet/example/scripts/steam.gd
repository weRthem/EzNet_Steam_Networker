extends Node

func _ready() -> void:
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))
	Steam.steamInitEx()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Steam.run_callbacks()
