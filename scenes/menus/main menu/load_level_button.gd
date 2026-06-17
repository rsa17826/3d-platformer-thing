@tool
extends Button

@export var levelnumber := 0:
  set(val):
    levelnumber = val
    setText()
func _init():
  setText()
func setText():
  text = "level " + str(levelnumber)

func _on_pressed():
  global.level = int(levelnumber)
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  get_tree().change_scene_to_file.call_deferred("res://scenes/levels/" + text + ".tscn")
