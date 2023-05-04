extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	BATTLE,
	HIDE,
	FLEE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO
var state = IDLE

onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var animationPlayer = $AnimationPlayer
onready var stats = $Stats
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true
	animationState.travel("Idle")

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			animationState.travel("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION *delta)
			seek_player()
		BATTLE:
			var player = playerDetectionZone.player
			animationTree.set("parameters/Run/blend_position", velocity)
			
			animationState.travel("Run")
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
		HIDE:
			seek_player()
			velocity = Vector2.ZERO
			animationState.travel("HideBarrel")
			var player = playerDetectionZone.player
			if player != null:
				state = BATTLE
		FLEE:
			var player = playerDetectionZone.player
			animationTree.set("parameters/Run/blend_position", velocity)
			animationState.travel("Run")
			if player != null:
				accelerate_away_from_point(player.global_position, delta)
			else:
				state = HIDE
	
	velocity = move_and_slide(velocity)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	state = FLEE

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

func accelerate_away_from_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(-direction * MAX_SPEED, ACCELERATION * delta)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = BATTLE
