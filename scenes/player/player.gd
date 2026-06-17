extends CharacterBody3D


const USER_MOVE_SPEED = 8.5
const USER_MOVE_SPEED_ICE = 13
var CURRENT_USER_MOVE_SPEED = 0
const JUMP_SPEED = 10.5
var MAX_JUMPS = 1
const MAX_KT = 5
var MOUSE_SENSITIVITY: float = 0
var KEY_MAX_BUFFER: int = 15
const MAXDASHCD = 3
const DASH_FOR_FRAMES = 10
const DASH_SPEED = 70
# const DASH_BOUNCE_FORCE = 10
# const DASH_BOUNCE_HEIGHT = 10

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func starts_with(x, y):
  return x.substr(0, len(y)) == y
func ends_with(x, y):
  return x.substr(len(x) - len(y)) == y

func _process(_delta):
  MOUSE_SENSITIVITY = float((Config.get_config("InputSettings", "MouseSensitivity", 3))) / 1000
  if inmenu || inbeforelevelstart:
    return
  if !global.timer.time:
    if Input.is_action_just_pressed("next level"):
      return
  var point = position
  point.y -= 1
  var temp = global.map.get_cell_item(global.map.local_to_map(point))
  if temp == -1:
    return
  if is_on_floor():
    blockunderplayer = temp

  CURRENT_USER_MOVE_SPEED = USER_MOVE_SPEED
  if starts_with(global.map.mesh_library.get_item_name(temp), "ice"):
    CURRENT_USER_MOVE_SPEED = USER_MOVE_SPEED_ICE

  global.debuguiadd("CURRENT_USER_MOVE_SPEED", CURRENT_USER_MOVE_SPEED)
  global.debuguiadd("bup", temp)
  global.debuguiadd("bup", global.map.mesh_library.get_item_name(temp))
var inbeforelevelstart := true
var inmenu := false
var jumps := 0
var kt: float = MAX_KT
var candash := false
var dashcd: float = 0
var dashing: float = 0
var blockunderplayer: int = -1
var tempstorage = {
  "predashvel": Vector3.ZERO,
  "tempstorage.dashdir": Vector3.ZERO,
}

# var boosting: float = 0

var speed := {
  "user": Vector3.ZERO,
  "dash": Vector3.ZERO,
  "dashbounce": Vector3.ZERO,
}


var trypress = {
  "jump": 0,
  "dash": 0
}
func pressed(key):
  return !!trypress[key]
func unpress(key):
  trypress[key] = 0
func press(key):
  trypress[key] = KEY_MAX_BUFFER

func _ready() -> void:
  $menu.visible = false
  $prelevelmenu.visible = true
  global.event.on("power got", power_got)
  global.timer.stop()
  global.timer.reset()
  # global.debuguistart()

    
func power_got():
  if global.player_ability == global.abilities.extrajump:
    kt = MAX_KT
    MAX_JUMPS = 2
    jumps += 1
  else:
    MAX_JUMPS = 1
  if global.player_ability == global.abilities.dash:
    candash = true
  else:
    candash = false

const cardtscn = preload("res://scenes/powers/cards.tscn")


func _input(event):
  if Input.is_action_just_pressed("throw card") && global.player_ability != global.abilities.none:
    var newcard = cardtscn.instantiate()
    # newcard.add_to_group("thrown")
    newcard.isthrown = true

    newcard.power = global.player_ability

    newcard.rotation = $cam.rotation
    newcard.position = position + Vector3(0, .5, -.20)

    get_tree().get_root().add_child(newcard)

    global.player_ability = global.abilities.none
    global.event.trigger("power got")

  if Input.is_action_just_pressed("replay level") && !inmenu:
    if inbeforelevelstart:
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
      get_tree().change_scene_to_file.call_deferred("res://addons/maaacks_options_menus/examples/scenes/menus/options_menu/master_options_menu_with_tabs.tscn")
    else:
      get_tree().reload_current_scene.call_deferred()
  if Input.is_action_just_pressed("next level"):
    if inbeforelevelstart:
      $prelevelmenu.visible = false
      inbeforelevelstart = false
      return
  if Input.is_action_just_pressed("settings menu"):
    if inbeforelevelstart:
      # get_tree().change_scene_to_file.call_deferred("res://addons/maaacks_options_menus/examples/scenes/menus/options_menu/master_options_menu_with_tabs.tscn")
      $prelevelmenu.visible = false
      inbeforelevelstart = false
    if inmenu && !inbeforelevelstart:
      $menu.visible = false
      Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
      inmenu = false
      global.timer.start()
    else:
      $menu.visible = true
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
      inmenu = true
      global.timer.stop()

  if event is InputEventMouseButton && !$menu.visible && !inbeforelevelstart:
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
  if event is InputEventMouseMotion && !$menu.visible && !inbeforelevelstart:
    $cam.rotation.y += -event.relative.x * MOUSE_SENSITIVITY
    $cam.rotation.x += -event.relative.y * MOUSE_SENSITIVITY
    var cap := 89.99
    if $cam.rotation_degrees.x > cap:
      $cam.rotation_degrees.x = cap
    if $cam.rotation_degrees.x < -cap:
      $cam.rotation_degrees.x = -cap
    $fake_cam.rotation = $cam.rotation
    $fake_cam.rotation.x = 0


func _physics_process(delta: float) -> void:
  if inmenu || inbeforelevelstart:
    return
  if !global.timer.time:
    if Input.is_action_just_pressed("next level"):
      return
    global.timer.start()
  global.debuguiclear()
  var has2 = []
  if global.player_ability == global.abilities.extrajump:
    has2.append("jump")
  updatetrypress(has2, delta)


  if is_on_floor():
    kt = MAX_KT
    jumps = MAX_JUMPS
    speed.user.y = 0
  else:
    speed.user.y -= gravity * delta
    if kt > 0:
      kt -= 60 * delta
    if jumps == MAX_JUMPS && kt <= 0:
      jumps = MAX_JUMPS - 1
  if dashcd > 0:
    if dashcd > 1 || is_on_floor():
      dashcd -= 60 * delta

  if pressed("jump") and jumps > 0:
    if speed.user.y <= 1:
      speed.user.y = JUMP_SPEED
      unpress("jump")
      jumps -= 1
    else:
      if trypress.jump <= 1:
        speed.user.y = JUMP_SPEED
        unpress("jump")
        jumps -= 1
        

  # if boosting <= 0:
  var input_dir := Input.get_vector("left", "right", "forward", "back")
  var movedir = Vector3(input_dir.x, 0, input_dir.y)
  var camdir = $fake_cam.transform.basis
  var direction = (camdir * movedir).normalized()
  # log.pp(kt, jumps)

  if direction:
    speed.user.x = direction.x * CURRENT_USER_MOVE_SPEED
    speed.user.z = direction.z * CURRENT_USER_MOVE_SPEED
  else:
    speed.user.x = move_toward(speed.user.x, 0, CURRENT_USER_MOVE_SPEED / 5)
    speed.user.z = move_toward(speed.user.z, 0, CURRENT_USER_MOVE_SPEED / 5)

  if candash && pressed("dash") && dashcd == 0:
    dashing = DASH_FOR_FRAMES
    dashcd = MAXDASHCD
    tempstorage.predashvel = speed.user
    tempstorage.dashdir = $fake_cam.transform.basis * Vector3.FORWARD
  if dashing > 0:
    unpress("dash")
    dashing -= 60 * delta
    speed.dash = ($fake_cam.transform.basis * Vector3.FORWARD) + (tempstorage.dashdir * DASH_SPEED)
    # log.pp(tempstorage.dashdir, speed.dash)
    # if is_on_wall_only() and dashing > 1:
    #   # boosting = 12
    #   dashing = 1
    if dashing <= 1:
      speed.dash = Vector3.ZERO
  # if boosting > 0:
  #   boosting -= 60 * delta
  #   speed.dashbounce = Vector3(0, DASH_BOUNCE_HEIGHT, 0) - (tempstorage.dashdir * DASH_BOUNCE_FORCE)
  # else:
  #   speed.dashbounce = Vector3.ZERO
  velocity = Vector3.ZERO
  for thisspeed in speed.keys():
    velocity += speed[thisspeed]
    global.debuguiadd("speed." + thisspeed, speed[thisspeed])
    # speed[thisspeed] *= .95
  global.debuguiadd("dashing", dashing)
  global.debuguiadd("dashcd", dashcd)
  global.debuguiadd("position", position)
  global.debuguiadd("inbeforelevelstart", inbeforelevelstart)
  global.debuguiadd("jumpiung", trypress["jump"])
  global.debuguiadd("global.level", global.level)
  # global.debuguiadd("boosting", boosting)
  # log.pp(speed.dash)
  move_and_slide()

func updatetrypress(has2: Array, delta):
  for thing in trypress.keys():
    if trypress[thing] > 0:
      trypress[thing] -= 60 * delta
    if thing in has2:
      if Input.is_action_just_pressed(thing) || Input.is_action_just_pressed(thing + '2'):
        trypress[thing] = KEY_MAX_BUFFER
      if !(Input.is_action_pressed(thing) || Input.is_action_pressed(thing + '2')):
        trypress[thing] = 0
      if Input.is_action_just_released(thing):
        trypress[thing] = 0
      if Input.is_action_just_released(thing + "2"):
        trypress[thing] = 0
    else:
      if Input.is_action_just_pressed(thing):
        trypress[thing] = KEY_MAX_BUFFER
      if !Input.is_action_pressed(thing):
        trypress[thing] = 0
      if Input.is_action_just_released(thing):
        trypress[thing] = 0
      # if Input.is_action_just_pressed(thing) || Input.is_action_just_pressed(thing + '2'):
      #   trypress[thing] = true
      # if !(Input.is_action_pressed(thing) || Input.is_action_pressed(thing + '2')):
      #   trypress[thing] = false
