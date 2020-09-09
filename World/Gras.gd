extends Node2D

var GrassEffect = load("res://Effects/GrasEffect.tscn")
		
func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	grassEffect.global_position = global_position

func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()
