extends Node2D

@onready var popup_tuto = $popup_tuto
@onready var clique_sfx = $clique_sfx
@onready var clique_animation_sprite = $animation_clique

var clique_sfx_liste: Array = [
	preload("res://sons/clique_sfx1.wav"),
	preload("res://sons/clique_sfx2.wav"),
	preload("res://sons/clique_sfx3.wav"),
	preload("res://sons/clique_sfx4.wav"),
	preload("res://sons/clique_sfx5.wav"),
	preload("res://sons/clique_sfx6.wav"),
	preload("res://sons/clique_sfx7.wav"),
	preload("res://sons/clique_sfx8.wav"),
	preload("res://sons/clique_sfx9.wav"),
	preload("res://sons/clique_sfx10.wav"),
	preload("res://sons/clique_sfx11.wav")
]

var clique_animations_liste: Array = [
	preload("res://textures/clique_animation.png")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	# à chaque fois que le joueur clique, on joue un des effets sonores aléatoires
	if event.is_action_pressed("clique_gauche"):
		# effet sonore de clique
		clique_sfx.stream = clique_sfx_liste.pick_random()
		clique_sfx.play(0.0)
		
		# animation de clique
		if clique_animation_sprite.is_playing():
			clique_animation_sprite.stop()
			
		clique_animation_sprite.position = get_viewport().get_mouse_position()
		clique_animation_sprite.play("animation" + str(randi_range(1, 3)))

func save_game():
	# la destination du fichier de sauvegarde
	var fichier_sauvegarde = FileAccess.open("user://sauvegarde.save", FileAccess.WRITE)
	
	for persistent_node in get_tree().get_nodes_in_group("persistant"):
		# on récupère les données
		var données_node = persistent_node.save()
		
		# on les convertie en fichier JSON
		var données_json = JSON.stringify(données_node)
		
		# on sauvegarde
		fichier_sauvegarde.store_line(données_json)


func _on_tree_entered() -> void:
	# on affiche le popup de tutoriel
	pass


func _on_check_button_toggled(toggled_on: bool) -> void:
	# sauvegarder le choix
	if toggled_on:
		pass
	else:
		pass
	pass # Replace with function body.


func _on_button_pressed() -> void:
	popup_tuto.queue_free()


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))


func _on_animation_clique_animation_finished() -> void:
	clique_animation_sprite.animation = "default"
