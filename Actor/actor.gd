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
#@export var myself = self
@export var isAlive: bool = true

@export var sight_range: float = 5 * GlobalSettings.UNIT : set = set_sight_range
@export var effective_range_max: float = 1 * GlobalSettings.UNIT : set = set_effective_range_max
@export var effective_range_min: float = 0 * GlobalSettings.UNIT : set = set_effective_range_min
@export var trigger_range: float = 1 * GlobalSettings.UNIT : set = set_trigger_range


#-------------------------------------------------------------------------------
# States
#-------------------------------------------------------------------------------
var arrivedAtTarget: bool = false



#-------------------------------------------------------------------------------
# Actor Variables
#-------------------------------------------------------------------------------
@onready var body_sprite: Sprite2D = %BodySprite
@onready var collbody := %CollBody
@onready var actor_anim_tree: AnimationTree = $AnimationPlayer/AnimationTree
@onready var FOV_area: Area2D = $Pivot/FOV_Area
@onready var pivot_marker: Marker2D = $Pivot
@onready var weapon_marker: Marker2D = %WeaponMarker
@onready var actor_anim_tree_mode = actor_anim_tree["parameters/playback"]
signal EnemySpotted
var isPlayer: bool = false
var actor_formation_index: int : set = set_actor_formation_index # player's position in formation

var move_target: Vector2

var actor_target_velocity: Vector2
var enemy_array: Array
var weapon

#-------------------------------------------------------------------------------
# Party Variables
#-------------------------------------------------------------------------------
var party_manager: PartyManager
var pb: Dictionary # party blackboard


#-------------------------------------------------------------------------------
# Conditions
#-------------------------------------------------------------------------------
var is_enemy_in_sight_range: bool = false
var is_enemy_in_trigger_range: bool = false
var is_enemy_in_effective_range: bool = false


#-------------------------------------------------------------------------------
# SetGets
#-------------------------------------------------------------------------------
func set_sight_range(new_sight_range):
	sight_range = new_sight_range * GlobalSettings.UNIT
	FOV_area.shape.set_scale(sight_range + 2 * GlobalSettings.UNIT)

func set_effective_range_max(new_effective_range_max):
	effective_range_max = new_effective_range_max * GlobalSettings.UNIT

func set_effective_range_min(new_effective_range_min):
	effective_range_min = new_effective_range_min * GlobalSettings.UNIT

func set_trigger_range(new_trigger_range):
	trigger_range = new_trigger_range * GlobalSettings.UNIT

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

func set_actor_formation_index(new_formation_index):
	actor_formation_index = pb.active_actors.find(self)


#-------------------------------------------------------------------------------
# Initialization
#-------------------------------------------------------------------------------
func spawn(spawn_data):
	party_manager = spawn_data.party_manager
	pb = spawn_data.party_blackboard
	add_to_group(pb.party_id)
	set_actor_faction_outline()
	set_global_position(spawn_data.spawn_pos)
	add_to_group(pb.party_group)
	if pb.party_group == "Player":
		isPlayer = true
#	move_target = pb.party_formation.vector_array[actor_formation_index]
	FOV_area.scale = Vector2(get_view_distance(), get_view_distance())
	for weapon in weapon_marker.get_children():
		weapon.group = pb.party_group
		var weapon_offset: int = 75
		weapon.set_position(Tools.random_offset(weapon_marker.get_position(), weapon_offset))
		weapon = weapon


func set_actor_faction_outline():
	body_sprite.get_material().set_shader_parameter("color", pb.party_shader_colour)


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _physics_process(delta):
	managed_process()
	set_actor_faction_outline()

func managed_process():
	set_actor_conditions()
	if isPlayer:
		player_state_process()
	elif !isPlayer:
		enemy_state_process()
#	steering_move(actor_target_velocity)
	steering_move(SBL.steering_vectors_processor(steering_vector_array, max_speed))


func steering_move(final_velocity: Vector2):
	velocity += (final_velocity - velocity) * turn_force
	move_and_slide()


func set_actor_conditions():
	set_move_target()


func set_move_target():
	if pb.isFormationActive:
		move_target = pb.party_formation.vector_array[actor_formation_index]
	else:
		move_target = pb.party_target_pos

#-------------------------------------------------------------------------------
# Action functions
#-------------------------------------------------------------------------------
func move_to_target(weight: float = 0.5):
	pass # add velocity to target to array

func move_to_enemy(weight: float = 0.5):
	pass # add velocity to target to array

func move_away_from_enemy(weight: float = 0.5):
	pass # add velocity to target to array
#-------------------------------------------------------------------------------
# Events
#-------------------------------------------------------------------------------
func take_damage(damage: float):
	modify_health(-damage)
	# play damage effect/move to damage state or something


#func spawn_weapon(new_weapon):
#	var weapon = SceneLib.spawn_child(new_weapon, weapon_marker)
#	var radius: int = GlobalSettings.UNIT / 3.5
#	weapon.set_position(Tools.random_offset(weapon_marker.get_position(), radius))
#	weapon.group = pb.party_group
#	weapon_array.append(weapon)
#
#func remove_weapon(weapon):
#	weapon_array.erase(weapon)
#	weapon.queue_free()
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

func player_state_process():
	pass

func enemy_state_process():
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
func rotate_weapon():
	var angle: float = get_global_position().angle_to(velocity)
	weapon.set_rotation(angle - PI)


func _on_fov_area_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_fov_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
