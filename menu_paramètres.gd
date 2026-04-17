extends Control

# on charge les textes et les boutons
@onready var b_bouton_quitter = $fond/grille_menu/bouton_quitter

var est_ouvert: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	b_bouton_quitter.text = tr("PAR_SAV_BUTTON")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func fermer():
	queue_free()

func traduire():
	b_bouton_quitter.text = tr("PAR_SAV_BUTTON")


func _notification(what: int) -> void:
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if not is_node_ready():
			await ready
		else:
			traduire()


func _on_bouton_quitter_pressed() -> void:
	fermer()
