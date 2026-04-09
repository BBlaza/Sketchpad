extends Control

@export var tool_tab: TabContainer
@export var editor: Editor

var _project: Project


func attach_project(project: Project) -> void:
	_project = project


func _on_tool_list_tab_changed(tab: int) -> void:
	editor.current_tool = tool_tab.get_tab_control(tab).tool
