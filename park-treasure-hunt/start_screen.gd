extends Control

@onready var park_scene = preload("res://Park.tscn")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event):
	if event is InputEventKey and event.pressed:
		var new_scene = park_scene.instantiate()
		var tree = get_tree()
		var root = tree.root
		if tree.current_scene:
			tree.current_scene.queue_free()
		root.add_child(new_scene)
		tree.current_scene = new_scene
