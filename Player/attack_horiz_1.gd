extends Area2D

var isFlipH = false

func flip_h(newFlip) -> void:
	if newFlip != isFlipH:
		position = -position
		scale = Vector2(-scale[0],scale[1])
		isFlipH = newFlip
