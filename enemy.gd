extends CharacterBody2D

var speed = 40
var player_detected = false
var player = null
var health = 3

#if something enters its detection radius
func _on_detection_radius_body_entered(body: Node2D) -> void:
	player = body
	player_detected = true

#if something leaves detection radius
func _on_detection_radius_body_exited(body: Node2D) -> void:
	player = null
	player_detected = false


func _physics_process(delta: float) -> void:
	if player_detected:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("slime_move")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("slime_idle")

