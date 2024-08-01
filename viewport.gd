extends Camera2D

@export var randomStrength: float = 20.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength: float = 0.0

func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength,0,shakeFade * delta)
		
		offset = randomOffset()

func apply_shake():
	shake_strength = randomStrength
	
func randomOffset():
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))



func _on_combat_enemy_attack() -> void:
	apply_shake()
