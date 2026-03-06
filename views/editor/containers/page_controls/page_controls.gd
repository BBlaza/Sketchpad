class_name PageControls
extends Node

signal menu_toggle

signal play_toggle

signal onion_skin_toggle

@export var menu_button: Button

@export var next_page_button: Button
@export var page_count_label: Label
@export var prev_page_button: Button

@export var framerate_slider: Slider
@export var framerate_label: Label

@export var play_button: Button

@export var onion_skin_button: Button

var is_playing = false

var _project: Project


func attach_project(project: Project):
	if _project and _project.new_current_page.is_connected(_update_view):
		_project.new_current_page.disconnect(_update_view)

	_project = project

	if _project:
		_project.new_current_page.connect(_update_view)


func _update_view(_page: Page) -> void:
	framerate_slider.value = _project.framerate
	framerate_label.text = str(int(_project.framerate))
	page_count_label.text = "%d/%d" % [_project._current_frame + 1, _project.frames.size()]


func _on_next_button_pressed() -> void:
	if _project:
		_project.next_page(false)


func _on_prev_button_pressed() -> void:
	if _project:
		_project.prev_page()


func _on_play_pressed() -> void:
	play_toggle.emit()
	is_playing = !is_playing

	play_button.text = "Pause" if is_playing else "Play"
	next_page_button.disabled = !next_page_button.disabled
	prev_page_button.disabled = !prev_page_button.disabled


func _on_slider_value_changed(value: float) -> void:
	framerate_label.text = str(int(value))
	_project.framerate = value


func _on_menu_button_pressed() -> void:
	menu_toggle.emit()


func _on_onion_skin_pressed() -> void:
	onion_skin_toggle.emit()
