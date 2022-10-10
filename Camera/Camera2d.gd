extends Camera2D


var master : get = get_master
var target_position: Vector2 = Vector2.ZERO : set = set_target_position, get = get_target_position
@export var zoom_level: float = 3 : set = set_zoom_level, get = get_zoom_level
const MIN_ZOOM: float = 0.7
const MAX_ZOOM: float = 10.0
@export var ZOOM_RATE: float = 5.0
@export var ZOOM_INCREMENT: float = 0.1

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
func init(_new_master, _new_master_position: Vector2 = Vector2.ZERO):
	set_master()


func _ready() -> void:
	set_master()

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	zoom_level = lerp(zoom_level, desired_zoom, ZOOM_RATE * delta)
	self.set_zoom(Vector2(zoom_level, zoom_level))

	set_target_position(get_master().pb.party_target_pos)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_zoomout"):
		zoom_out()
	if Input.is_action_just_pressed("ui_zoomin"):
		zoom_in()


func zoom_in():
	if (desired_zoom - ZOOM_INCREMENT) >= MIN_ZOOM:
		desired_zoom -= ZOOM_INCREMENT

func zoom_out():
	if (desired_zoom - ZOOM_INCREMENT) <= MAX_ZOOM:
		desired_zoom += ZOOM_INCREMENT
