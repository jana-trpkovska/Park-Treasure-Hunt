extends Control

func _ready():
	# Connect the button signal
	$CenterContainer/VBoxContainer/RestartButton.pressed.connect(_on_restart_pressed)

func _on_restart_pressed():
	# Reload the main game scene
	get_tree().change_scene_to_file("res://Park.tscn")  

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
