extends Node2D

@export var speed = 100
@export var same_movement_proba = 0.5

const possible_vectors = [Vector2(-1, -1), Vector2(-1, 0), Vector2(-1, 1), Vector2(0, -1), Vector2(0, 1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1)]

var characters = []
var following_characters = []
var character_vector = []
var character_controlled = 0
func _ready():
	characters = get_node("Characters").get_children()
	for i in range(len(characters)):
		following_characters.append(true)
		character_vector.append(possible_vectors[0])
	character_controlled = randi() % len(characters)
	randomize_characters()
	get_tree().create_timer(1.0).timeout.connect(randomize_characters)

func randomize_characters():
	for i in range(len(characters)):
		following_characters[i] = randf() < same_movement_proba
		character_vector[i] = possible_vectors[randi() % 8]
	get_tree().create_timer(1.0).timeout.connect(randomize_characters)
	

func _physics_process(_delta):
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	characters[character_controlled].linear_velocity = direction * speed
	for i in range(len(characters)):
		if i != character_controlled:
			if direction != Vector2.ZERO:
				characters[i].linear_velocity = (direction if following_characters[i] else character_vector[i]) * speed
			else:
				characters[i].linear_velocity = Vector2.ZERO
