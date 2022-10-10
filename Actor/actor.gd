extends CharacterBody2D

class_name Actor

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export var speed: int
@export var friction: float
@export var fov: int
@export var view_distance: int
@export var health: int
@export var turn_force: float



#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
var arrivedAtTarget: bool = false



#-------------------------------------------------------------------------------
# Actor Variables
#-------------------------------------------------------------------------------
@export @onready var body_sprite: Sprite2D
@export @onready var actor_anim_tree: AnimationTree
@export @onready var weapon_scene: PackedScene
@export @onready var FOV_area: Area2D
@export @onready var pivot_marker: Marker2D
@export @onready var weapon_marker: Marker2D
@onready var actor_anim_tree_mode = actor_anim_tree["parameters/playback"]


#-------------------------------------------------------------------------------
# Party Variables
#-------------------------------------------------------------------------------
var party_manager: PartyManager
var pb: Dictionary # party blackboard


#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func spawn(spawn_data):
	party_manager = spawn_data.party_manager
	pb = spawn_data.pb
	set_global_position(spawn_data.spawn_pos)
	add_to_group(pb.party_group)

#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func managed_process():
	state_process()

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
