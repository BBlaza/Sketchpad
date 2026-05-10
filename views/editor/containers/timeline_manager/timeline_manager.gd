class_name TimelineManager
extends Control

@export var image_timeline: HBoxContainer
@export var audio_timeline: HBoxContainer
@export var new_layer_button: Button
@export var copy_layer_button: Button
@export var cut_layer_button: Button

var _project: Project

func attach_project(proj: Project) -> void:
	_project = proj
	_project.frames_update.connect(setup_image_timeline)
	new_layer_button.pressed.connect(create_new_layer)


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

		var layer_data := make_layer_dictionary(frames[frame_index].layers, frames[frame_index].names)
		layers_list.set_data(layer_data)
		
		if frame_index == _project.current_frame:
			layers_list.current_layer = _project.current_layer
			
		layers_list.update_cell_styles()


func make_layer_dictionary(images: Array[Image], names: Array[String]) -> Dictionary[String, Image]:
	if images.size() != names.size():
		push_error("The length of layers and names do not match.")
	
	var result: Dictionary[String, Image] = {}

	for layer_index in range(images.size()):
		var cur_name := names[layer_index]
		var cur_image := images[layer_index]
		result[cur_name] = cur_image

	return result


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


func create_new_layer() -> void:
	var frame_idx = _project.current_frame
	
	_project.frames[frame_idx].create_layer(_project.width, _project.height)
