extends Node2D

func _on_host_pressed() -> void:
	# Add 'await' here because host_game() is now a coroutine
	var result = await MultiplayerManager.host_game()
	if result != OK:
		print("Failed to host!")

func _on_join_pressed() -> void:
	# Even if join_game doesn't have an await yet, it's good practice 
	# to keep it consistent if you plan to add scene loading waits there too
	var result = await MultiplayerManager.join_game()
	if result != OK:
		print("Failed to join!")
