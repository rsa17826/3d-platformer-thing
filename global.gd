@tool
extends Node
# tilemap
# file
# arr
# event

#
var player_ability = abilities.none
enum abilities {
  none,
  extrajump,
  dash,
}
var map: GridMap
const levelnames = {
  0: "test level",
  1: "level 1",
  2: "test level",
}

const filepath = {
  "besttimes": "user://besttimes.json"
}
var level: int
var targetdist: float = INF

func same(x, y):
  return typeof(x) == typeof(y) and x == y

func join(joiner="", a="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", s="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", d="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", f="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", g="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", h="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", j="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", k="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", l="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", z="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", x="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", c="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", v="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", b="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", n="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", m="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", q="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", w="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", e="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", r="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", t="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", y="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", u="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", i="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", o="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD", p="HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD"):
  var temparr = [a, s, d, f, g, h, j, k, l, z, x, c, v, b, n, m, q, w, e, r, t, y, u, i, o, p]
  temparr = temparr.filter(func(e):
    return !same(e, "HDSJAKHADSJKASHDHDSJKASDHJDSAKHASJKD")
    )
  return joiner.join(temparr)
func _process(delta):
  if timer.started:
    timer.time += delta
class timer:
  static var time: float = 0
  static var started: bool = false
  static func reset():
    timer.time = 0
  static func format(temptime="DJKASDHjkaDHJkashdjkAS") -> String:
    var time: float = timer.time if global.same(temptime, "DJKASDHjkaDHJkashdjkAS") else float(temptime)
    var minutes := time / 60
    var seconds := fmod(time, 60)
    var milliseconds := fmod(time, 1) * 100
    return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
  static func stop():
    timer.started = false
  static func start():
    timer.started = true

func debuguistart():
  event.trigger("debugui start")

func debuguiclear():
  if event.triggers.has("debugui clear"):
    event.trigger("debugui clear")

func debuguiadd(name, val):
  if event.triggers.has("debugui add"):
    event.trigger("debugui add", name, val)

class tilemap:
  static func save(tile_map: TileMap):
    var layers = tile_map.get_layers_count()
    var tile_map_layers = []
    tile_map_layers.resize(layers)
    for layer in layers:
      tile_map_layers[layer] = tile_map.get("layer_%s/tile_data" % layer)
    return tile_map_layers
  static func load(tile_map: TileMap, data: Array) -> void:
    for layer in data.size():
      var tiles = data[layer]
      tile_map.set('layer_%s/tile_data' % layer, tiles)

class file:
  static func write(path, text, asjson=true):
    FileAccess.open(path, FileAccess.WRITE_READ).store_string(JSON.stringify(text) if asjson else text)
  static func read(path, asjson=true, default=''):
    var f = FileAccess.open(path, FileAccess.READ)
    if !f:
      FileAccess.open(path, FileAccess.WRITE_READ).store_string(default)
      return JSON.parse_string(default) if asjson else default
      # return null if asjson else default
    if asjson:
      if JSON.parse_string(f.get_as_text()) != null:
        return JSON.parse_string(f.get_as_text())
      else:
        if JSON.parse_string(default) != null:
          return JSON.parse_string(default)
        else:
          breakpoint
          return default
    else:
      return f.get_as_text()
class arr:
  static func getcount(array, count):
    var newarr = []
    for i in range(count):
      if array.size() == 0: return null
      newarr.append(array[0])
      array.remove_at(0)
    return newarr
class event:
  static var triggers: Dictionary = {}
  static func trigger(msg: String, data1="AHDSJKHDASJK", data2="AHDSJKHDASJK", data3="AHDSJKHDASJK") -> void:
    if !msg in triggers:
      log.error('no triggers set for call', msg)
      return
    for cb: Callable in triggers[msg]:
      if cb != null and cb.is_valid():
        var default = "AHDSJKHDASJK"
        if global.same(data3, default):
          if global.same(data2, default):
            if global.same(data1, default):
              cb.call()
            else:
              cb.call(data1)
          else:
            cb.call(data1, data2)
        else:
          cb.call(data1, data2, data3)
  static func off(obj: Dictionary) -> void:
    var msg: String = obj.msg
    var i: int = obj.index
    if !msg in triggers:
      log.error(triggers, 'cant remove ' + str(i) + ' from ' + msg + ' because ' + msg + ' doesnt exist')
      return
    if len(triggers[msg]) <= i:
      log.error(triggers[msg], 'cant remove ' + str(i) + ' from ' + msg + ' because ' + str(i) + ' doesnt exist in ' + msg)
      return
    triggers[msg][i] = func() -> void: pass
  static func on(msg: String, cb: Callable) -> Dictionary:
    if !msg in triggers:
      triggers[msg] = []
    triggers[msg].append(cb)
    return {'msg': msg, 'index': len(triggers[msg]) - 1}

func _ready():
  DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)