### Jennifer Guajardo ###
# This is a variation of the other rotate script.
# While unused, I experimented with this in order to fix that Y-axis issue I asked about in the discord.

extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate around the object's local Z axis by 0.02 radians.
	rotate_object_local(Vector3(0, 1, 0), 0.02)
	pass
