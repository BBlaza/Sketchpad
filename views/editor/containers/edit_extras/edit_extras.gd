class_name EditExtras
extends FullPanel

@export var tab_container: TabContainer

var _project: Project

func attach_project(project: Project):
	_project = project
	for node in tab_container.get_children():
		if node.has_method("attach_project"):
			node.attach_project(project)
