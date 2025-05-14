extends Area2D

var player = null
var player_intransition_zone = false

func _on_body_entered(body):
	player = body
	if body.has_method("player"):
		player_intransition_zone = false
		get_tree().change_scene_to_file("res://Scenes/you_won.tscn")


func _on_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_intransition_zone = false
