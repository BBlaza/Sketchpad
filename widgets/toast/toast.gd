extends Control

@export var display_duration: float = 2.0
@export var anim_speed: float = 0.3

var _tween: Tween

@onready var label: Label = $MarginContainer/Panel/Label

## Shows the toast with the given text. [br]
## [param text]: The text in the toast. [br]
## [param duration]: The duration of the toast.
func show_message(text: String, duration: float = -1.0) -> void:
	if duration < 0:
		duration = display_duration

	label.text = text
	visible = true

	# Kill any existing tween
	if _tween:
		_tween.kill()

	position.y = 80
	_tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:y", 0, anim_speed)
	await get_tree().create_timer(duration).timeout
	_tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	_tween.tween_property(self, "position:y", 80, anim_speed)
	await _tween.finished
	visible = false
