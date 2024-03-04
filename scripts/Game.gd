extends Node2D

onready var MainMenuCursor = load("res://assets/ui/Cursor/Menu_corsur_Version4.png")
func _ready():
	Input.set_custom_mouse_cursor(MainMenuCursor, 0, Vector2( 32, 32 ))
