extends CharacterBody2D

@export var move_speed = 300.0
@export var jump_height = -400.0

@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $Hitbox/CollisionShape2D

var flipped := false

enum State {
	Idle,
	Run,
	Punch
}

var state: State = State.Idle
var in_range := false
var hitbox_hit := false
var fighter_direction := 1

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("punch"):
		state = State.Punch

func _physics_process(delta):
	match state:
		State.Idle:
			animation_player.play("idle")
			var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			if direction.length() > 0:
				state = State.Run
		State.Run:
			animation_player.play("run")

			var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
			if direction.length() == 0:
				velocity.x = move_toward(velocity.x, 0, move_speed)
				velocity.y = move_toward(velocity.y, 0, move_speed)
			if velocity.x == 0 and velocity.y == 0:
				state = State.Idle
			if direction.x <= -0.5:
				if not flipped:
					transform.x *= -1
					flipped = true
					fighter_direction = -1
			elif direction.x >= 0.5:
				if flipped:
					transform.x *= -1
					flipped = false
					fighter_direction = 1

			velocity.x = direction.x * move_speed
			velocity.y = direction.y * move_speed
			move_and_slide()

		State.Punch:
			animation_player.play("punch")


func set_state(new_state: State) -> void:
	state = new_state

func _on_range_area_entered(area):
	in_range = true

func _on_hitbox_area_entered(area: Area2D):
	if in_range:
		if area.get_parent().has_method("take_hit"):
			area.get_parent().take_hit(Vector2(1, 0) * fighter_direction)

func _on_range_area_exited(area):
	in_range = false
