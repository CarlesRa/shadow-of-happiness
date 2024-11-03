extends Node

func change_scene(node: Node2D, scene: PackedScene):
	node.get_tree().change_scene_to_packed(scene)
