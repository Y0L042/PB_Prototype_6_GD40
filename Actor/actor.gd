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
# Actor Variables
#-------------------------------------------------------------------------------
@export @onready var body_sprite: Sprite2D
@export @onready var actor_anim_tree: AnimationTree
@export @onready var sm: Resource
@onready var actor_anim_tree_mode
@onready var weapon_scene
@onready var FOV_area
@onready var pivot

var actor_target: Vector2

#-------------------------------------------------------------------------------
# Party Variables
#-------------------------------------------------------------------------------
var party_manager: PartyManager
var pb: Dictionary # party blackboard

var group: String


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
	sm.state_process()




func steering_move(final_velocity: Vector2):
	pass

func take_damage(damage: int):
	pass

func simple_attack(target_enemy):
	pass






#-------------------------------------------------------------------------------
# Signal Functions
#-------------------------------------------------------------------------------



#-------------------------------------------------------------------------------
# Animation
#-------------------------------------------------------------------------------
func flip_sprite(look_dir: Vector2 = velocity): #please improve this
	var flip_buffer: float = 25
	var flipped: bool = false
	if look_dir.x < -flip_buffer: flipped = true
	if look_dir.x > flip_buffer: flipped = false
	# Flip pivot
	if flipped and (pivot.scale.x == 1):
		pivot.set_scale(Vector2(-1, 1))
	if !flipped and (pivot.scale.x == -1):
		pivot.set_scale(Vector2(1, 1))


func rotate_sword():
	var angle: float = get_global_position().angle_to(velocity)
	weapon_scene.set_rotation(angle - PI)
