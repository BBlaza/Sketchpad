class_name TimelineManager
extends Control


var project: Project
signal project_ready


func attach_project(proj: Project) -> void:
	project = proj
	project_ready.emit()
