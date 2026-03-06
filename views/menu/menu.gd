class_name Menu
extends FullPanel

@export var gallery: Gallery
@export var editor: Editor
@export var version_label: Label

func _ready() -> void:
	version_label.text = ProjectSettings.get_setting("application/config/version")

func _new_project_clicked() -> void:
	editor.new_project()
	self.close()

func _on_view_clicked() -> void:
	gallery.open()
	self.close()
