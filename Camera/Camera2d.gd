extends Camera2D


var master : get = get_master
var target_position: Vector2 = Vector2.ZERO : set = set_target_position, get = get_target_position
@export var zoom_level: float = 3 : set = set_zoom_level, get = get_zoom_level
@export var MIN_ZOOM: float = 0.7
@export var MAX_ZOOM: float = 10.0
@export var ZOOM_RATE: float = 5.0
@export var ZOOM_INCREMENT: float = 0.1
@export var setMaster: bool = false

var desired_zoom: float = zoom_level

#-------------------------------------------------------------------------------
# SetGet
#-------------------------------------------------------------------------------
func set_master():
	master = get_parent()
func get_master():
	return master

func set_zoom_level(new_zoom_level):
	zoom_level = new_zoom_level
func get_zoom_level():
	return zoom_level

func set_target_position(new_target_position: Vector2):
	target_position = new_target_position
	set_global_position(target_position)
func get_target_position():
	return target_position

#-------------------------------------------------------------------------------
# Initialize
#-------------------------------------------------------------------------------
func _ready() -> void:
	if setMaster:
		set_master()


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if master:
		set_target_position(get_master().pb.party_target_pos)
#	zoom_level = lerp(zoom_level, desired_zoom, ZOOM_RATE * delta)
	set_zoom(Vector2(zoom_level, zoom_level))



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("game_act_zoomout"):
		zoom_level *= 2
		zoom_out()
	if Input.is_action_just_pressed("game_act_zoomin"):
		zoom_level /= 2
		zoom_in()


func zoom_in():
	if (desired_zoom - ZOOM_INCREMENT) >= MIN_ZOOM:
		desired_zoom -= ZOOM_INCREMENT

func zoom_out():
	if (desired_zoom - ZOOM_INCREMENT) <= MAX_ZOOM:
		desired_zoom += ZOOM_INCREMENT
