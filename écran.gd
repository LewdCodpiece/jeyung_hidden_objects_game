class_name Ecran extends Node2D

@export var nom: String
@export var débloqué: bool = false

@onready var liste_objets_node = $"objets-cachés"
@onready var liste_indices_node = $hud/liste_indices

@onready var hud = $hud
@onready var indices_cd = $hud/transparent_cd
@onready var menu_échap = $"hud/menu_échap"

@onready var réaction = $"réaction"

var est_fini: bool = false
# pour la visibilité de la liste d'indices
var indices_in_focus: bool = false

# controle si on peut fermer le menu échap
var menu_échap_bloqué: bool = false

signal fini()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# le menu échap n'est pas visible au lancement du niveau
	menu_échap.visible = false
	# on connecte les signaux "trouvé"s de tous les objets de la scène
	# à tester si fini, pour que voir si l'écran est completé
	# et pour suivre le progrès du jouer
	for obj in liste_objets_node.get_children():
		if obj is Objet:
			obj.trouvé.connect(_tester_si_fini) # test si la win condition est rempli
			obj.trouvé.connect(_maj_liste_indices) # montre les indices avec 
			obj.trouvé.connect(_réagir_trouvé) # active les réactions / effets sonores quand un objet est trouvé
			
			# on met à jour la description de chaque objet pour faire en sorte qu'elle suive la langue du jeu
			obj.translate_name()
	# fait la liste des indices
	_maj_liste_indices()
	# traduction
	translate_menu()

func translate_menu():
	# on traduit les boutons du menu échap
	$"hud/menu_échap/menu_boutons/bouton_paramètre".text = tr("MENU_ECHAP_RETURN")
	$"hud/menu_échap/menu_boutons/bouton_paramètre".text = tr("MENU_SETTINGS")
	$"hud/menu_échap/menu_boutons/bouton_quiter".text = tr("MENU_QUIT")

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready
		else:
			translate_menu()
			
			for obj: Objet in liste_objets_node.get_children():
				obj.translate_name()
			
			_maj_liste_indices()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# on change la transparence des indices en fonction du temps
	# restant dans le timer
	if not indices_in_focus:
		liste_indices_node.modulate.a = indices_cd.time_left / indices_cd.wait_time

func _input(event: InputEvent) -> void:
	# on ne peut ouvrir le menu de niveau que quand le niveau est ouvert
	if self.visible and not menu_échap_bloqué:
		if event.is_action_released("échap"):
			menu_échap.visible = not menu_échap.visible

func _tester_si_fini():
	if liste_objets_node.get_children().all(func f(x): return x.est_trouvé):
		# tous les objets de la scènes sont trouvés,
		# le joueur a fini l'écran, on envoie le signal correspondant
		fini.emit()


func _on_fini() -> void:
	# on remplit les différentes étapes logiques nécessaires
	# à la confirmation de la victoire
	print("fini")


func _on_visibility_changed() -> void:
	if self.visible and not indices_in_focus:
		# on lance le cd des indices
		indices_cd.start()


func _on_liste_indices_mouse_entered() -> void:
	# rend visible les indices de façon
	# constante tant que la souris est dedans
	liste_indices_node.modulate.a = 1.0
	indices_in_focus = true


func _on_liste_indices_mouse_exited() -> void:
	# on lance le cd des indices
	indices_in_focus = false
	indices_cd.start()
	
	
func _maj_liste_indices():
	# on vide la liste des indices
	for i in liste_indices_node.get_children():
		i.queue_free()
	# met à jour la liste des indices
	for obj: Objet in liste_objets_node.get_children():
		if obj is Objet:
			if not obj.est_trouvé:
				var label_indices = Label.new()
				label_indices.text = obj.nom
				label_indices.custom_minimum_size.x = 200
				label_indices.autowrap_mode = TextServer.AUTOWRAP_WORD
				label_indices.label_settings = load("res://indice_label_settings.tres")
				
				liste_indices_node.add_child(label_indices)
	
	indices_cd.start()


func _on_bouton_return_pressed() -> void:
	# on ferme le menu
	self.menu_échap.visible = false


func _on_bouton_paramètre_pressed() -> void:
	# on ouvre la page des paramètres depuis la scène
	var menu_param = load("res://menu_paramètres.tscn").instantiate()
	
	hud.add_child(menu_param)
	
	# le menu échap est débloqué quannd le menu paramètre est quitté
	menu_param.b_bouton_quitter.pressed.connect(
		func deez():
			menu_échap_bloqué = false
	)
	
	menu_échap_bloqué = true


func _on_bouton_quiter_pressed() -> void:
	# on quitte le niveau
	self.visible = false
	# on ouvre le menu de choix des niveaux
	get_parent().get_parent().get_node("menu_choix_monde").visible = true
	# on ferme le menu échap
	menu_échap.visible = false


func save() -> Dictionary:
	# fonction qui renvoie le dictionnaire de données sauvegardées
	
	var dict_données: Dictionary = {
		"filename": get_scene_file_path(),
		"parent": get_parent().get_path(),
		"débloqué": self.débloqué,
		"nom": self.nom,
		"fini": self.est_fini
	}
	
	return dict_données

func _réagir_trouvé():
	réaction.jouer_réaction()
