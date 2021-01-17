extends Node2D

func _process(delta):
	if Input.is_action_just_pressed("Input_restart"):
		get_tree().change_scene("res://Practice_Scene.tscn")
