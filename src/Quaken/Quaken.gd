extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	BATTLE,
	CHARGE,
	HIDE,
	FLEE
}

onready var animationPlayer = $AnimationPlayer
onready var stats = $Stats
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	animationState.travel("Idle")


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
