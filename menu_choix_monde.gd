extends Control

@onready var n_listes_monde = $fond/scroll/liste_mondes

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


# appelé quand l'écran est éteint/allumé
func _on_liste_mondes_visibility_changed() -> void:
	if not is_node_ready():
		await ready
	else:
		if self.visible: # = le menu vient d'tre ouvert, on met à jour l'afficage
			# on vide l'affichage avant de le remplir à nouveau
			for node in n_listes_monde.get_children():
				node.queue_free()
			# mondes
			for m in range(1, MondeGlobals.nb_mondes+1):
				var liste_mondes = HBoxContainer.new()
				
				for écran: Ecran in get_tree().get_nodes_in_group("monde" + str(m)):
					var nouveau_bouton_écran = TextureButton.new()
					
					# les textures
					nouveau_bouton_écran.texture_normal = load("res://textures/fonds/" + écran.nom + "/" + écran.nom + "-vignette.png")
					# texture niveau pas encore débloqué
					nouveau_bouton_écran.texture_disabled = load("res://textures/écran-bloqué.png")
					
					# connecter les signaux pour lancer le niveau
					nouveau_bouton_écran.pressed.connect(
						func lambda():
							écran.visible = true
							self.visible = false
					)
					# signal indiquant que le niveau est terminé
					# mais pas quiter, débloque le niveau/monde suivant
					écran.fini.connect(
						func lambda():
							if get_tree().get_nodes_in_group("monde" + str(m))[-1] != écran:
								get_tree().get_nodes_in_group("monde" + str(m))[get_tree().get_nodes_in_group("monde" + str(m)).find(écran)+1].débloqué = true
							else:
								# dernier niveau, on débloque un nouveau monde
								if get_tree().has_group("monde"+str(m+1)):
									get_tree().get_nodes_in_group("monde" + str(m+1))[0].débloqué = true
								else:
									# dernier monde
									pass
					)
					# on désactive si le niveau est pas débloqué
					nouveau_bouton_écran.disabled = not écran.débloqué
					# on ajoute
					liste_mondes.add_child(nouveau_bouton_écran)
					
				n_listes_monde.add_child(liste_mondes)
