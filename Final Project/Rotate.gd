### Jennifer Guajardo ###
# Ripped straight from this classes earlier tutorials, this is needed for several rotating obstacles.

extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate around the object's local X axis by 0.05 radians.
	rotate_object_local(Vector3(1, 0, 0), 0.05)
	pass

# This was likely misplaced. Although, I don't want to delete it just in case.
func _on_warp_area_4_body_entered(body):
	pass # Replace with function body.
