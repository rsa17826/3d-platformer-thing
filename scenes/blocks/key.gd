extends Node3D

func _on_area_entered(area: Area3D):
  if area.is_in_group("thrown"):
    # area.get_parent().queue_free()
    queue_free()

func _on_body_entered(body):
  if body.is_in_group("player"):
    queue_free()
