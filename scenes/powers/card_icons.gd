extends Node3D

@export var default_icon: global.abilities = global.abilities.none

func _ready() -> void:
  global.event.on("power got", power_got)
  global.player_ability = default_icon
  hideall()
  shownode(default_icon)
  global.event.trigger.call_deferred("power got")
  $Area3D.queue_free()

func power_got():
  hideall()
  shownode(global.player_ability)

func hideall():
  for i in get_node("icons").get_child_count():
    get_node("icons").get_child(i).visible = false

func shownode(i):
  get_node("icons").get_node(str(i)).visible = true
