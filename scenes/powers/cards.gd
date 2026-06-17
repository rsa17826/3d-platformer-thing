extends Node3D

@export var power: global.abilities = global.abilities.none

# thrown by player
const SPEED = 120
const ROTSPEED = 40

@onready var dir = global_transform.basis.z
var rotx = rotation.x
var roty = rotation.y
var rotz = rotation.z

var isthrown = false

func _ready() -> void:
  hideall()
  if isthrown:
    $Area3D.add_to_group("thrown")
    $icons.rotate_z(-90)
    $base.rotate_z(-90)
    $Area3D.rotate_z(-90)
  shownode(power)

func _physics_process(delta: float) -> void:
  if isthrown:
    visible = true
    position -= dir * SPEED * delta
    rotate_x(dir.x * delta * ROTSPEED)
    rotate_y(dir.y * delta * ROTSPEED)
    rotate_z(dir.z * delta * ROTSPEED)
  else:
    rotate_y(delta * 5)


func hideall():
  for i in get_node("icons").get_child_count():
    get_node("icons").get_child(i).visible = false

func shownode(i):
  get_node("icons").get_node(str(i)).visible = true


func _on_area_3d_body_entered(body: Node3D) -> void:
  if !visible: return
  if isthrown: return
  if body.is_in_group("player"):
    global.player_ability = power
    global.event.trigger("power got")
    visible = false
    await get_tree().create_timer(4.0).timeout
    visible = true


func _on_timer_timeout():
  if isthrown:
    queue_free.call_deferred()


func _on_blockcollision_body_entered(body: Node3D):
  if isthrown:
    if body.name == "blocks":
      queue_free()
