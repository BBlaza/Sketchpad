class_name Gallery
extends FullPanel

@export var item_list: ItemList
@export var editor: Editor
@export var menu: FullPanel
@export var project_view: ProjectView
@export var file_picker: FileDialog

var file_access_web: FileAccessWeb
var projects: Array[Project]

func _ready() -> void:
	if OS.has_feature("web"):
		_ensure_file_access_web()

func open():
	super.open()
	fetch_projects()


## Gathers all the projects in the sketchpad_projects folder for viewing.
func fetch_projects():
	item_list.clear()
	var dir = DirAccess.get_files_at(Consts.PROJ_PATH)
	for file in dir:
		if file.get_extension() == "res":
			var proj = load(Consts.PROJ_PATH.path_join(file))
			if proj is Project:
				item_list.add_item(proj.title, proj.get_thumbnail())


func _on_item_selected(index: int) -> void:
	var title = item_list.get_item_text(index)
	var project = ResourceLoader.load("%s/%s.res" % [Consts.PROJ_PATH, title])
	project_view.load_in(project)
	item_list.deselect_all()


func _on_back_pressed() -> void:
	menu.open()
	self.close()


## Gathers a file to start the import process.
func import_project() -> void:
	if OS.has_feature("web"):
		_ensure_file_access_web()
		file_access_web.open(".res")
		return
	file_picker.show()
	var path = await file_picker.file_selected
	if path:
		var project = ResourceLoader.load(path)
		finish_import(project)
	fetch_projects()

## Called to save imported project.
## [param project]: The project being imported.
func finish_import(project: Project) -> void:
	if project is Project:
		DirAccess.make_dir_absolute(Consts.PROJ_PATH)
		ResourceSaver.save(
			project, "%s/%s.res" % [Consts.PROJ_PATH, project.title], ResourceSaver.FLAG_COMPRESS
		)
		Toast.show_message("Imported %s!" % project.title)
	else:
		Toast.show_message("Not a project file.")

# Web File Access Handlers
func _on_file_loaded(_file_name: String, _file_type: String, base64_data: String) -> void:
	var bytes = Marshalls.base64_to_raw(base64_data)

	var file = FileAccess.open("user://temp.res", FileAccess.WRITE)
	if not file:
		Toast.show_message("Failed to process file data.")
		return
	file.store_buffer(bytes)
	file.close()

	var project = ResourceLoader.load("user://temp.res")
	if project == null:
		DirAccess.remove_absolute("user://temp.res")
		Toast.show_message("Failed to load project file.")
		return

	finish_import(project)

	DirAccess.remove_absolute("user://temp.res")
	fetch_projects()

func _on_file_error() -> void:
	Toast.show_message("Failed to read the selected file.")

func _on_file_cancelled() -> void:
	Toast.show_message("File selection cancelled.")

func _ensure_file_access_web() -> void:
	if file_access_web:
		return
	file_access_web = FileAccessWeb.new()
	file_access_web.loaded.connect(_on_file_loaded)
	file_access_web.error.connect(_on_file_error)
	file_access_web.upload_cancelled.connect(_on_file_cancelled)
