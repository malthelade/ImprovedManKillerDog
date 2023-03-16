extends Node2D

var stats = PlayerStats
var health_increase = 1

func _on_Area2D_body_entered(_body):
	stats.health += health_increase
	queue_free()
	



