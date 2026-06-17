extends Node3D

@export var id: int = 0

func _ready():
  if !id:
    log.err("target: id not set")
    
func _on_area_entered(area: Area3D):
  if area.is_in_group("thrown"):
    # for node in get_tree().get_nodes_in_group("target"):
    #   if node.id==self.id:
    #     queue_free()
    #     return

    # for node in get_tree().get_nodes_in_group("doors"):
    #   if node.id==self.id:
    #     node.queue_free()
    queue_free()
