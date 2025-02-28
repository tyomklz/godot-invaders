extends Node2D

const GAME_OVER_SCENE = preload("res://ui/game_over/game_over.tscn")

func _init():
	Globals.lives = Globals.max_lives
	Globals.points = 0

func _ready():
	Events.lives_changed.connect(func(lives): check_game_over())
	Events.enemy_died.connect(check_game_over)
	Events.enemies_row_changed.connect(check_game_over)
	get_tree().paused = false

func check_game_over():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var enemy_group = get_tree().get_first_node_in_group("enemy_group")
	if Globals.lives <= 0 or enemies.size() <= 0 or enemy_group.global_position.y > 140:
		show_game_over()

func show_game_over():
	for rocket in get_tree().get_nodes_in_group("rocket"):
		rocket.queue_free()
	for enemy_bullet in get_tree().get_nodes_in_group("enemy_bullet"):
		enemy_bullet.queue_free()
	add_child(GAME_OVER_SCENE.instantiate())
	get_tree().paused = true
