extends Node2D

@onready var animation = $animation

var nb_réactions: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	nb_réactions = len(Array(animation.get_animation_list())) - 1 # on ne compte pas RESET


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func jouer_réaction():
	var réaction_numéro: int = randi_range(1, nb_réactions)
	animation.play("apparition"+ str(réaction_numéro).pad_zeros(2))
