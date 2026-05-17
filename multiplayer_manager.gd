extends Node

const PORT = 7777
var player_scene = preload("res://player.tscn") # Make sure path is correct

func host_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		return error
	
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(add_player)
	
	# Load the game world
	get_tree().change_scene_to_file("res://game.tscn")
	
	# Add the host (yourself) once the scene is ready
	# We use a timer or call_deferred to ensure the game scene exists first
	await get_tree().create_timer(0.1).timeout
	add_player(multiplayer.get_unique_id())
	return OK

func join_game():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client("localhost", PORT)
	if error != OK:
		return error
		
	multiplayer.multiplayer_peer = peer
	get_tree().change_scene_to_file("res://game.tscn")
	return OK

func add_player(id: int):
	var player = player_scene.instantiate()
	player.name = str(id)
	
	# Find the 'Game' node in the current scene tree
	var world = get_tree().root.get_node_or_null("Game")
	if world:
		world.add_child(player)
	else:
		# Fallback if the game scene isn't named "Game"
		get_tree().root.add_child(player)
