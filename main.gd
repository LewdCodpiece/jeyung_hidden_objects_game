extends Node2D


@onready var popup_tuto = $popup_tuto

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
