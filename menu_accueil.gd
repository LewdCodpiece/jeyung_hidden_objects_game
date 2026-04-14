extends Control

# boutons du menu principal
@onready var b_commencer = $fond/menus/bouton_commencer
@onready var b_paramètres = $"fond/menus/bouton_paramètres"
@onready var b_crédits = $"fond/menus/bouton_crédits"
@onready var b_quitter = $fond/menus/bouton_quitter

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# on charge le texte des boutons en fonction de la langue
	b_commencer.text = tr("MENU_START")
	b_paramètres.text = tr("MENU_SETTINGS")
	b_crédits.text = tr("MENU_CREDITS")
	b_quitter.text = tr("MENU_QUIT")


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready
		else:
			traduire()

func traduire():
	b_commencer.text = tr("MENU_START")
	b_paramètres.text = tr("MENU_SETTINGS")
	b_crédits.text = tr("MENU_CREDITS")
	b_quitter.text = tr("MENU_QUIT")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_bouton_paramètres_pressed() -> void:
	var menu_paramètre = load("res://menu_paramètres.tscn").instantiate()
	get_parent().add_child(menu_paramètre)


func _on_bouton_commencer_pressed() -> void:
	var deez = load("res://menu_choix_monde.tscn").instantiate()
	get_parent().add_child(deez)
	deez.visible = true
	self.queue_free()


func _on_bouton_quitter_pressed() -> void:
	get_parent().get_parent().queue_free()
