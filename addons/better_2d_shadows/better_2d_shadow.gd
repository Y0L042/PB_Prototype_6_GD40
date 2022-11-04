extends Sprite2D

class_name BetterShadow2D


#-------------------------------------------------------------------------------
# Variables
#-------------------------------------------------------------------------------
var shadow_sprite: Sprite2D 



#-------------------------------------------------------------------------------
# Exported Variables
#-------------------------------------------------------------------------------
@export var LightGroupID: String = "BetterLight2D#137"
@export var ShadowGroupID: String = "BetterShadow2D#137"


#-------------------------------------------------------------------------------
# Runtime
#-------------------------------------------------------------------------------
func _init():
	add_to_group(ShadowGroupID)
	shadow_sprite = self.duplicate()
	shadow_sprite.set_global_position(self.get_global_position())
	add_child(shadow_sprite)
	
func cast_shadow():
	pass
	
func update_light_source():
	pass

