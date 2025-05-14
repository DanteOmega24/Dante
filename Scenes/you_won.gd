extends Control


func _on_play_again_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/control.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
