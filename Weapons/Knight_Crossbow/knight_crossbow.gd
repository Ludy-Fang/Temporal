extends Node2D

@onready var bolt : PackedScene = preload("res://Weapons/Knight_Crossbow/knight_crossbow_bolt.tscn")
@export var player : CharacterBody2D


func _process(_delta):
	if Input.is_action_pressed("shoot"):
		shooting()

func shooting():
	
	var bolt_instance = bolt.instantiate()
	bolt_instance.rotation = player.rotation
	bolt_instance.global_position = player.global_position
	add_child(bolt_instance)
