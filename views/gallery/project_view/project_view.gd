class_name ProjectView
extends FullPanel

@export_category("UI Elements")
@export var name_label: Label
@export var date_label: Label
@export var frame_label: Label

@export_category("External Connections")
@export var editor: Editor
@export var gallery: Gallery

@export_category("Project Preview")
@export var canvas: Canvas
@export var viewport: SubViewport
@export var playback_manager: PlaybackManager
@export var aspect: AspectRatioContainer

var _project: Project

## Loads in a provided [param project].
func load_in(project: Project):
	_project = project
	load_info()
	super.open()

## Populates the project viewer with the project's information.
func load_info() -> void:
	name_label.text = _project.title
	frame_label.text = str(len(_project.frames)) + " Frames"
	date_label.text = _project.last_saved

	canvas.attach_project(_project)
	playback_manager.attach_project(_project)

	viewport.size_2d_override = Vector2i(_project.width, _project.height)
	if _project.height > 0:
		aspect.ratio = float(_project.width) / float(_project.height)
	playback_manager.is_playing = true

## Empties the project viewer when it closes.
func unload_info() -> void:
	name_label.text = ""
	frame_label.text = ""
	date_label.text = ""

	_project = null
	playback_manager.is_playing = false
	canvas.attach_project(_project)
	playback_manager.attach_project(_project)

## Triggers a load in the editor.
func trigger_load() -> void:
	editor.load_project(_project)
	close()
	gallery.close()

func close() -> void:
	super.close()
	unload_info()
