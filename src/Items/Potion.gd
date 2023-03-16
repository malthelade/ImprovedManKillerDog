extends Node2D

var stats = PlayerStats
var health_increase = 1
onready var sprite = $Sprite


func _on_Area2D_body_entered(body):
	stats.health += health_increase
	queue_free()
	



func set_type(potion_type):
	sprite.frame = potion_type
