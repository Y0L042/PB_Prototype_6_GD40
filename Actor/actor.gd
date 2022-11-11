extends CharacterBody2D

class_name Actor

#-------------------------------------------------------------------------------
# Properties
#-------------------------------------------------------------------------------
@export var max_speed: int = GlobalSettings.UNIT * 1 : set = set_max_speed
@export var friction: float
@export var fov: int
@export var view_distance: float = GlobalSettings.UNIT * 1 : set = set_view_distance
@export var health: int : set = set_health
@export var turn_force: float
@export var myself = self
@export var isAlive: bool = true



#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
var arrivedAtTarget: bool = false



#-------------------------------------------------------------------------------
# Actor Variables
#-------------------------------------------------------------------------------
@onready var body_sprite: Sprite2D = %BodySprite
@onready var actor_anim_tree: AnimationTree = $AnimationPlayer/AnimationTree
@onready var FOV_area: Area2D = $Pivot/FOV_Area
@onready var pivot_marker: Marker2D = $Pivot
@onready var weapon_marker: Marker2D = %WeaponMarker
@onready var actor_anim_tree_mode = actor_anim_tree["parameters/playback"]

signal EnemySpotted

var actor_target_velocity: Vector2
var FOV_enemy_list: Array
var weapon_array: Array

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

func set_health(new_health):
	health = new_health

func modify_health(health_modifier):
	health += health_modifier
	if health <= 0:
		isAlive = false

#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func spawn(spawn_data):
	party_manager = spawn_data.party_manager
	pb = spawn_data.party_blackboard
	set_actor_faction_outline()
	set_global_position(spawn_data.spawn_pos)
	add_to_group(pb.party_group)
	FOV_area.scale = Vector2(get_view_distance(), get_view_distance())
	for weapon in weapon_marker.get_children():
		weapon.group = pb.party_group
		var weapon_offset: int = 75
		weapon.set_position(Tools.random_offset(weapon_marker.get_position(), weapon_offset))
		weapon_array.append(weapon)


func set_actor_faction_outline():
	body_sprite.get_material().set_shader_parameter("color", pb.party_shader_colour)


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta):
	managed_process()
	set_actor_faction_outline()

func managed_process():
	state_process()
#	steering_move(actor_target_velocity)
	steering_move(SBL.steering_vectors_processor(steering_vector_array, max_speed))


func steering_move(final_velocity: Vector2):
	velocity += (final_velocity - velocity) * turn_force
	move_and_slide()

#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func take_damage(damage: float):
	modify_health(-damage)
	# play damage effect/move to damage state or something


func spawn_weapon(new_weapon):
	var weapon = SceneLib.spawn_child(new_weapon, weapon_marker)
	var radius: int = GlobalSettings.UNIT / 3.5
	weapon.set_position(Tools.random_offset(weapon_marker.get_position(), radius))
	weapon.group = pb.party_group
	weapon_array.append(weapon)

func remove_weapon(weapon):
	weapon_array.erase(weapon)
	weapon.queue_free()
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


func rotate_weapon():
	var angle: float = get_global_position().angle_to(velocity)
	for weapon in weapon_array:
		weapon.set_rotation(angle - PI)
