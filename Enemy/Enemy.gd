extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
func _ready() -> void:
	animated_sprite.play("Idle")

func take_damage(damage) -> void:
	animated_sprite.play("Death")

func _on_animated_sprite_2d_animation_looped() -> void:
	if (animated_sprite.animation == "Death"):
		queue_free()
