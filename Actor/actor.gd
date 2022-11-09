extends CharacterBody2D

class_name Actor

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export var max_speed: int : set = set_max_speed
@export var friction: float
@export var fov: int
@export var view_distance: float : set = set_view_distance
@export var health: int
@export var turn_force: float



#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
var arrivedAtTarget: bool = false



#-------------------------------------------------------------------------------
# Actor Variables
#-------------------------------------------------------------------------------
@onready var body_sprite: Sprite2D = $Pivot/BodySprite
@onready var actor_anim_tree: AnimationTree = $AnimationPlayer/AnimationTree
@export @onready var weapon_scene: PackedScene
@onready var FOV_area: Area2D = $Pivot/FOV_Area
@onready var pivot_marker: Marker2D = $Pivot
@onready var weapon_marker: Marker2D = $Pivot/WeaponMarker
@onready var actor_anim_tree_mode = actor_anim_tree["parameters/playback"]

var actor_target_velocity: Vector2

#-------------------------------------------------------------------------------
# Party Variables
#-------------------------------------------------------------------------------
var party_manager: PartyManager
var pb: Dictionary # party blackboard

#-------------------------------------------------------------------------------
# SetGet
#-------------------------------------------------------------------------------
func set_max_speed(new_max_speed):
	max_speed = new_max_speed * GlobalSettings.UNIT

func set_view_distance(new_view_distance):
	view_distance = new_view_distance
func get_view_distance() -> float:
	return view_distance

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func spawn(spawn_data):
	party_manager = spawn_data.party_manager
	pb = spawn_data.party_blackboard
	set_global_position(spawn_data.spawn_pos)
	add_to_group(pb.party_group)
	FOV_area.scale = Vector2(get_view_distance(), get_view_distance())

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta):
	managed_process()

func managed_process():
	state_process()
	steering_move(actor_target_velocity)
#	steering_move(SBL.steering_vectors_processor(steering_vector_array, max_speed))


func steering_move(final_velocity: Vector2):
	velocity += (final_velocity - velocity) * turn_force
	move_and_slide()


#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
var current_state: int
var steering_vector_array: PackedVector2Array

#-------------------------------------------------------------------------------
# State Machine
#-------------------------------------------------------------------------------
func change_state(NEW_STATE: int):
	current_state = NEW_STATE

func state_process():
	pass

#-------------------------------------------------------------------------------
# State Functions
#-------------------------------------------------------------------------------
func state_process_passive():
	pass

func state_process_aggressive():
	pass

func state_process_hurt():
	pass

func state_process_dead():
	pass



#-------------------------------------------------------------------------------
# Signal Functions
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# Animation
#-------------------------------------------------------------------------------
func flip_sprite(look_dir: Vector2 = velocity): #please improve this
	# var flip_buffer: float = 25
	# var flipped: bool = false
	# if look_dir.x < -flip_buffer: flipped = true
	# if look_dir.x > flip_buffer: flipped = false
	# # Flip pivot
	# if flipped and (pivot.scale.x == 1):
	# 	pivot.set_scale(Vector2(-1, 1))
	# if !flipped and (pivot.scale.x == -1):
	# 	pivot.set_scale(Vector2(1, 1))
	pass


func rotate_sword():
	var angle: float = get_global_position().angle_to(velocity)
	weapon_scene.set_rotation(angle - PI)
