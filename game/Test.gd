extends Node2D

class_name Test

func get_class(): return "Test"
func is_class(name): return name == "Test" or .is_class(name) 


func _ready():
	print("TEST:", get_class())
	print("TEST:", is_class("Test"))
	print("TEST:", is_class("Node2D"))