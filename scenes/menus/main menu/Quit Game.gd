extends Button


func _on_draw():
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  get_tree().quit()
