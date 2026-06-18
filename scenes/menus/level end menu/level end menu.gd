extends Control
var thislevel = global.level

func _ready():
  var levelstr = str(thislevel)
  log.pp(global.timer.format())
  var newbesttimes = global.file.read(global.filepath.besttimes, true, "{}")
  var justgotnewbesttime = false
  var prevtime = INF
  if newbesttimes.has(levelstr):
    if newbesttimes[levelstr] > global.timer.time:
      prevtime = newbesttimes[levelstr]
      newbesttimes[levelstr] = global.timer.time
      justgotnewbesttime = true
    else:
      prevtime = newbesttimes[levelstr]
  else:
    newbesttimes[levelstr] = global.timer.time

  if prevtime == INF:
    $vbox/timertext.text = global.join("",
    "beat the level with TIME OF: ",
    global.timer.format(),
    )
  else:
    if justgotnewbesttime:
      $vbox/timertext.text = global.join("",
      "NEW BEST TIME OF: ",
      global.timer.format(),
      "\nbeat old time of: ",
      global.timer.format(prevtime),
      "\nby: ",
      global.timer.format(prevtime - global.timer.time)
      )
    else:
      $vbox/timertext.text = global.join("",
      "beat with a time of: ",
      global.timer.format(),
      "\noff of new best by: \n",
      global.timer.format(global.timer.time - prevtime)
      )

  global.file.write(global.filepath.besttimes, newbesttimes)

func _input(_event):
  if Input.is_action_just_pressed("next level"):
    log.pp("next level", global.level, thislevel)
    global.level = thislevel + 1
    get_tree().change_scene_to_file.call_deferred("res://scenes/levels/" + global.levelnames[global.level] + ".tscn")
  if Input.is_action_just_pressed("replay level"):
    log.pp(" level", global.level, thislevel)
    log.pp("same level")
    get_tree().change_scene_to_file.call_deferred("res://scenes/levels/" + global.levelnames[global.level] + ".tscn")
