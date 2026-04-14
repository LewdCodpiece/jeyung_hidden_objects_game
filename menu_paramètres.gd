extends Control

# on charge les textes et les boutons
@onready var l_langue = $"fond/grille_menu/langue_jeu/nom_entrée"
@onready var b_langue = $fond/grille_menu/langue_jeu/liste_langues
@onready var b_bouton_quitter = $fond/grille_menu/bouton_quitter

var est_ouvert: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#self.visible = false
	# on charge la bonne traduction
	l_langue.text = tr("PAR_LANG_LABEL")
	
	b_langue.add_item("Français" + " (" + tr("PAR_LANG_FR") +")", 2)
	b_langue.add_item("English" + " (" + tr("PAR_LANG_EN") +")", 1)
	b_langue.add_item("Jéyûng" + " (" + tr("PAR_LANG_JE") +")", 0)
	b_langue.selected = 0
	
	b_bouton_quitter.text = tr("PAR_SAV_BUTTON")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fermer():
	queue_free()

func _on_liste_langues_item_selected(index: int) -> void:
	match index:
		0: TranslationServer.set_locale("je")
		1: TranslationServer.set_locale("en")
		2: TranslationServer.set_locale("fr")

func traduire():
	l_langue.text = tr("PAR_LANG_LABEL")
	
	b_langue.set_item_text(0, "Jéyûng" + " (" + tr("PAR_LANG_JE") +")")
	b_langue.set_item_text(1, "English" + " (" + tr("PAR_LANG_EN") +")")
	b_langue.set_item_text(2, "Français" + " (" + tr("PAR_LANG_FR") +")")
	
	b_bouton_quitter.text = tr("PAR_SAV_BUTTON")
	

func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready
		else:
			traduire()


func _on_bouton_quitter_pressed() -> void:
	fermer()
