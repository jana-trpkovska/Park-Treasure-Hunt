extends Area3D

@export var value: int = 1  # Points per coin

signal collected(value)

func _ready():
	# Automatically add this coin to the "coins" group
	add_to_group("coins")
	connect("body_entered", _on_body_entered)

func _process(delta):
	# Rotate the coin to make it spin
	rotate_y(delta * 2)

func _on_body_entered(body):
	if body is CharacterBody3D:  # Ensure only the player collects it
		collected.emit(value)  # Emit signal when collected
		queue_free()  # Remove the coin from the scene
