extends RayCast3D


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  if is_colliding():
    var origin = global_transform.origin
    var collision_point = get_collision_point()
    var distance = origin.distance_to(collision_point)
    global.targetdist = distance
  else:
    global.targetdist = INF
