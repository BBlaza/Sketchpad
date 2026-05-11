class_name TimelineManager
extends Control

@export var image_timeline: HBoxContainer
@export var audio_timeline: HBoxContainer
@export var new_layer_button: Button
@export var copy_layer_button: Button
@export var cut_layer_button: Button
@export var paste_layer_button: Button
@export var delete_layer_button: Button

var current_list: LayersList
var pasteboard_images: Array[Image]
var pasteboard_names: Array[String]

var _project: Project

func attach_project(proj: Project) -> void:
	_project = proj
	_project.frames_update.connect(setup_image_timeline)
	new_layer_button.pressed.connect(_creating_new_layer)
	copy_layer_button.pressed.connect(_on_click_copy)
	cut_layer_button.pressed.connect(_on_click_cut)
	paste_layer_button.pressed.connect(_on_click_paste)
	delete_layer_button.pressed.connect(_deleting_layers)


func setup_image_timeline() -> void:
	var frames := _project.frames
	for child in image_timeline.get_children():
		child.queue_free()

	for frame_index in range(frames.size()):
		var layers_list := LayersList.new()

		layers_list.frame_index = frame_index

		layers_list.title = "Frame " + str(frame_index + 1)
		layers_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		layers_list.size_flags_vertical = Control.SIZE_EXPAND_FILL

		image_timeline.add_child(layers_list)
		layers_list.selection_changed.connect(_on_layers_list_selection_changed)
		layers_list.copy_layers.connect(_copying_layers)

		layers_list.set_data(frames[frame_index])
		
		if frame_index == _project.current_frame:
			layers_list.current_layer = _project.current_layer
			
		layers_list.update_cell_styles()


func _on_layers_list_selection_changed(source: LayersList) -> void:
	for child in image_timeline.get_children():
		var layers_list := child as LayersList

		if layers_list == null:
			continue

		if layers_list != source:
			layers_list.clear_selection()
			if source.selected_indices.size() == 1:
				layers_list.current_layer = -1
	
	if source.selected_indices.size() == 1:
		_project.change_to_frame(source.frame_index)
		_project.current_layer = source.selected_indices[0]
		source.current_layer = _project.current_layer
		current_list = source


func _creating_new_layer() -> void:
	var frame_idx = _project.current_frame
	_project.frames[frame_idx].create_layer(_project.width, _project.height, _project.current_frame)


func _deleting_layers() -> void:
	var deleting_idx := current_list.selected_indices
	deleting_idx.sort()
	deleting_idx.reverse()
	
	for idx in deleting_idx:
		current_list.displayed_page.delete_layer(idx)
	
	setup_image_timeline()


func _copying_layers(pasteboard: Array[Image], names: Array[String]) -> void:
	pasteboard_images = pasteboard
	pasteboard_names = names


func _on_click_copy() -> void:
	current_list.copy()
	setup_image_timeline()


func _on_click_cut() -> void:
	current_list.cut()
	setup_image_timeline()


func _on_click_paste() -> void:
	current_list.paste(pasteboard_images, pasteboard_names)
	setup_image_timeline()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		var command_or_ctrl_pressed = event.ctrl_pressed or event.meta_pressed

		if not command_or_ctrl_pressed:
			match event.keycode:
				KEY_DELETE:
					_deleting_layers()

				KEY_BACKSPACE:
					_deleting_layers()

		else:
			match event.keycode:
				KEY_C:
					_on_click_copy()

				KEY_X:
					_on_click_cut()

				KEY_V:
					_on_click_paste()
