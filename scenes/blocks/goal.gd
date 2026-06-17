extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
    # log.pp(global.level)

func _on_body_entered(body: Node3D):
  if body.is_in_group("player"):
    if len(get_tree().get_nodes_in_group("target")): return
    global.timer.stop()

    get_tree().change_scene_to_file.call_deferred("res://scenes/menus/level end menu/level end menu.tscn")

    # get_tree().change_scene_to_file.call_deferred("res://scenes/levels/level " + str(global.level) + ".tscn")
    # log.pp(global.level)
