extends Button

var levelnumber := 0

func _on_pressed():
  global.level = int(levelnumber)
  Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  get_tree().change_scene_to_file.call_deferred("res://scenes/levels/" + text + ".tscn")
