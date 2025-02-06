extends Node3D

@onready var timer = $GameTimer
@onready var timer_label = $TimerLabel
@onready var coins_label = $CoinsLabel
@onready var game_over_screen = preload("res://Game_Over_Screen.tscn")
@onready var win_screen = preload("res://Win_Screen.tscn")

var treasures_collected = 0
var total_treasures = 5

@onready var player = $Player

func _ready():
	timer.start()  # Start the timer when the scene is ready
	
	# Connect the "collected" signal for coins
	for coin in get_tree().get_nodes_in_group("coins"):
		coin.connect("collected", Callable(self, "collect_treasure"))

func _process(delta):
	if player.game_ended:
		# Disable player movement when the game is over or won
		return
	
	# Update the Timer Label each frame
	var time_left = int(timer.time_left)
	var minutes = time_left / 60
	var seconds = time_left % 60
	timer_label.text = "Time: %02d:%02d" % [minutes, seconds]

func _on_game_timer_timeout():
	# Show game over screen when time runs out
	show_game_over()

func collect_treasure(value: int):
	# Add points when a coin is collected
	treasures_collected += value
	coins_label.text = "Coins: %d/%d" % [treasures_collected, total_treasures]
	print("Treasure collected")
	if treasures_collected >= total_treasures:
		show_win_screen()

func show_game_over():
	# Stop the timer, show game over screen, and stop all input
	player.game_ended = true
	timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Make the mouse visible
	var game_over_instance = game_over_screen.instantiate()
	add_child(game_over_instance)

func show_win_screen():
	# Stop the timer, show win screen, and stop all input
	player.game_ended = true
	timer.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Make the mouse visible
	var win_instance = win_screen.instantiate()
	add_child(win_instance)
