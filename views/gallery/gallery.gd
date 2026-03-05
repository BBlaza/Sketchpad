class_name Gallery
extends FullPanel

@export var item_list: ItemList
@export var editor: Editor
@export var menu: FullPanel
@export var project_view: ProjectView

var projects: Array[Project]

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
				item_list.add_item(
					proj.title,
					proj.get_thumbnail()
				)

func _on_item_selected(index: int) -> void:
	var title = item_list.get_item_text(index)
	var project = ResourceLoader.load("%s/%s.res" % [Consts.PROJ_PATH, title])
	project_view.load_in(project)
	item_list.deselect_all()

func _on_back_pressed() -> void:
	menu.open()
	self.close()
