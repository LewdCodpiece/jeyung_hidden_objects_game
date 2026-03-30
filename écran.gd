extends Node2D

@export var nom: String

@onready var liste_objets_node = $"objets-cachés"

var est_fini: bool = false

signal fini()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# on connecte les signaux "trouvé"s de tous les objets de la scène
	# à tester si fini, pour que voir si l'écran est completé
	# et pour suivre le progrès du jouer
	for obj in liste_objets_node.get_children():
		if obj is Objet:
			obj.trouvé.connect(_tester_si_fini)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _tester_si_fini():
	if liste_objets_node.get_children().all(func f(x): return x.est_trouvé):
		# tous les objets de la scènes sont trouvés,
		# le joueur a fini l'écran, on envoie le signal correspondant
		fini.emit()


func _on_fini() -> void:
	# on remplit les différentes étapes logiques nécessaires
	# à la confirmation de la victoire
	print("fini")
