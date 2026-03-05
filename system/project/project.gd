class_name Project
extends Resource

signal new_current_page(page: Page)

@export var title: String = "New Animation"
@export var framerate: float = 1.0

@export var width: int = 256
@export var height: int = 192

@export var frames: Array[Page]

@export var audio: AudioStream
@export var audio_clips: Dictionary[int, AudioStream]

@export var thumbnail: Image

@export var last_saved: String = "No Date"

var _current_layer: int = 0
var _current_frame: int = 0

## Initializes a new project. [br]
## Used instead of [code]_init[/code] to avoid overwriting loaded data.
func new_project(w: int, h: int) -> void:
	width = w
	height = h

	frames.append(Page.new(width, height))
	new_current_page.emit(frames[0])
	print("[Project] New project created")

## Returns the current focused page in the project.
func get_current_page() -> Page:
	return frames[_current_frame]

## Sets the current frame to a specific index. [br]
## Returns [code]null[/code] if the page does not exist. [br]
## [param index]: The index of the page.
func get_page_by_index(index: int = 0) -> Page:
	if index >= 0 and index < len(frames):
		_current_frame = index
		new_current_page.emit(frames[_current_frame])
		return frames[_current_frame]
	return null

## Returns a page some distance removed from the focused page in the project. [br]
## Returns [code]null[/code] if the page does not exist. [br]
## [param distance]: Determines how far to grab the page.
func get_distant_page(distance: int = 1) -> Page:
	if _current_frame + distance >= 0 and _current_frame + distance < len(frames):
		return frames[_current_frame + distance]
	return null

## Changes the current project page to the next page. [br]
## [param is_loop]: Goes back to page 0 if at the end. Adds a new page otherwise.
func next_page(is_loop: bool) -> Page:
	_current_frame += 1
	if len(frames) < (_current_frame + 1):
		if is_loop:
			_current_frame = 0
		else: frames.append(Page.new(width, height))
	new_current_page.emit(frames[_current_frame])
	return frames[_current_frame]

## Changes the current project page to the previous page. Stops at frame 0.
func prev_page() -> Page:
	if(_current_frame > 0):
		_current_frame -= 1
	new_current_page.emit(frames[_current_frame])
	return frames[_current_frame]

## Triggers project saving elements.
func on_project_save() -> void:
	last_saved = Time.get_datetime_string_from_system(false, true)

	var tn = frames[_current_frame].flatten()
	if tn:
		tn.resize(128, 96, Image.INTERPOLATE_NEAREST)
		thumbnail = tn

## Obtains the project's thumbnail as a Texture2D.
func get_thumbnail() -> Texture2D:
	var img = thumbnail
	if img != null:
		return ImageTexture.create_from_image(img)
	return load("res://system/project/placeholder_thumbnail.png")
