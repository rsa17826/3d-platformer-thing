extends Control

const MAX = 40.0

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  var dist
  if global.targetdist == INF:
    dist = MAX
  else:
    dist = global.targetdist

  # Invert the growth of circlefg
  var inverted_dist = MAX - dist

  $circlefg.set_size(Vector2(inverted_dist, inverted_dist))
  $circlebg.set_size(Vector2(MAX, MAX))
  $circlefg.set_position(Vector2(-inverted_dist / 2, -inverted_dist / 2))
  $circlebg.set_position(Vector2(-MAX / 2, -MAX / 2))
  if dist == MAX:
    $distdisp.text = str(round(global.targetdist))
  else:
    $distdisp.text = str(round(global.targetdist)) + " M"
