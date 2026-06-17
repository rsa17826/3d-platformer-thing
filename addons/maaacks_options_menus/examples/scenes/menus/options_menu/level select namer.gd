extends CaptureFocus


# Called when the node enters the scene tree for the first time.
func _ready():
  var children = get_children()
  var i = 0
  while i < len(children):
    var child = children[i]
    i += 1
    child.get_child(0).levelnumber = i
    if global.levelnames.has(i):
      child.get_child(0).text = global.levelnames[i]
    else:
      child.get_child(0).text = str(i)
