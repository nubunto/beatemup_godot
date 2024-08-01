extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var knockback_timer = $KnockbackTimer

enum State {
	Knockback,
	Idle
}

@export var knockback_scaling := 50.0

var state := State.Idle
var knockback := Vector2.ZERO

func _ready() -> void:
	animation_player.play("idle", -1, randf_range(0.1, 1.0))

func take_hit(knockback: Vector2):
	# apply knockback
	state = State.Knockback
	self.knockback = knockback
	knockback_timer.start()

func _physics_process(delta):
	match state:
		State.Idle:
			pass
		State.Knockback:
			velocity = knockback * knockback_scaling
			move_and_slide()


func _on_knockback_timer_timeout():
	state = State.Idle
