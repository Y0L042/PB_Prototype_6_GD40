extends CharacterBody2D


const ENEMY_SPEED = 100
const RAYS = 10
const RAY_LENGTH = 50

var target_location: Vector2 = Vector2.ZERO # set your target location, eg:
# 												ALMain.GetPlayer().get_global_position()





func _physics_process(delta: float) -> void:
	# Calculate direction to player
	var target_dir = get_global_position().direction_to(target_location)

	# Calculate new position after moving in player direction
	var new_pos = get_global_position() + target_dir * ENEMY_SPEED * delta


	var raycast_dir: Vector2 = new_pos.normalized()
	var raycast_rotation_offset = deg_to_rad(36)
	var offset_raycast_dir: Vector2 = raycast_dir
	var isRaycastIntersected = do_raycast(self.get_global_position(), raycast_dir * RAY_LENGTH).empty()
	while isRaycastIntersected:
		offset_raycast_dir = raycast_dir.rotated(raycast_rotation_offset)
		isRaycastIntersected = do_raycast(self.get_global_position(), self.get_global_position() + offset_raycast_dir * RAY_LENGTH).empty()
		if isRaycastIntersected:
			offset_raycast_dir = raycast_dir.rotated(-raycast_rotation_offset)
			isRaycastIntersected = do_raycast(self.get_global_position(), self.get_global_position() + offset_raycast_dir * RAY_LENGTH).empty()
			if isRaycastIntersected:
				raycast_rotation_offset *= 2
			else:
				break
		else:
			break


	velocity = offset_raycast_dir * ENEMY_SPEED * delta
	move_and_slide()


func do_line_raycast(from: Vector2, to: Vector2, col_mask = 0xFFFFFFFF, exclude_rid_array = []):
	var ray_query := PhysicsRayQueryParameters2D.create(from, to, col_mask, exclude_rid_array)
	var raycast = get_world_2d().direct_space_state.intersect_ray(ray_query)
	return raycast

