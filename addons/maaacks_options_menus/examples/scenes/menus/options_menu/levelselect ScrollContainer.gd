extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _process(delta):
  custom_minimum_size.y = get_tree().get_root().get_window().size.y - 100
