class_name Objet extends Area2D

@onready var sprite = $sprite

@export var nom: String = ""
var est_trouvé: bool = false

signal trouvé()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_released("clique_gauche"):
		if not est_trouvé:
			trouvé.emit()


func _on_trouvé() -> void:
	# l'objet est trouvé
	est_trouvé = true
	# on ajoute un overlay coloré pour montrer au joueur qu'il s'agit bien
	# d'un des objets qu'il cherche
	# on charge le shader dans un objet material
	var nouveau_matériaux = ShaderMaterial.new()
	nouveau_matériaux.shader = load("res://shader_obj_trouvé.gdshader")
	# on assigne le nouveau matériau shader
	sprite.material = nouveau_matériaux
