### BY: Jennifer Guajardo ###
# The bulk of the game's required code is in this script.
# This includes player movement, physics, the ability to warp between scenes, sound, etc.
# While this might be problematic in a full-fledged game, due to the sheer number of
# dependencies, it'll work for the sake of this project. 


extends CharacterBody3D

const SPEED = 5.5
const JUMP_VELOCITY = 5.0
var ResetClock = 0 # Used for reseting the game by holding "R".
var FlickerClock = 0 # Used to determine the timer for the scene changes when reaching the goal ring.
# Previously, the above variable was for a mechanic closer the player will run out of flashlight.

# This variable is used to determine speed of player moving the mouse.
# Oddly enough, it has to be negative in order to prevent it from being backwards.
# i.e. If I drag the mouse left, it will go right, and vice versa.
const MOUSE_MOVMENT = -0.01 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Control of the Flashlight is established.
# This is my attempt to manipulate the "SpotLight3D" node.
# Supposed to be turned ON/OFF
# I'm not using consistent labels because it's LITERALLY a flashlight.
@onready var Flashlight = $SpotLight3D 

# For the Flashlight sound effect.
# This is used alongside turning the flashlight ON/OFF
@onready var click = $"../Click" # NOT HAVING THE "CLICK" SOUND NODE WILL CAUSE AN ERROR

# Ambient Noise Start
# This is used as nice background noise to accompany the adventure.
@onready var ambience = $"../Ambience" # NOT HAVING THE "AMBIENCE" SOUND NODE WILL CAUSE AN ERROR

### CUT CODE ###
# Below variable was cut because there was originally a mechanic where the flashlight would just run out altogether.
# var reachTimeOut = 0 # Starts at zero, but will accumulate to 30 in the "_flicker()" event to simulate flashlights.
# This was meant for head rotation, but cut to simplify the process.
# @onready var head_attempt = $"Head Attempt"
#func _stepSFX():
	##Putting them all here so I don't have to copy-past in physics process.
	#if Input.is_action_pressed("forward"):
		#stepnoise.play()
	#if Input.is_action_pressed("backward"):
		#stepnoise.play()
	#if Input.is_action_pressed("leftward"):
		#stepnoise.play()
	#if Input.is_action_pressed("rightward"):
		#stepnoise.play()
	#

### CUT SFX & MUSIC ###
# These were cut due to problematic implementation or not being pleasant to the ears.
# Theme of the Flashlight Start
# This is used to indicate the flashlight is being expended.
# @onready var theme = $"../Flashlight Theme"
# This is the flicker noise for the flashlight. Used to indicate that it's running out.
# @onready var flicker = $"../Flicker"
# Footstep Noise
# Cut because it was too awkward to implement.
#@onready var stepnoise = $"../Footstep"



# Runs at the start of a scene.
func _ready():
	# This is meant to hide the mouse for a seemless first-person experience.
	# Use alt-tab to exit the window if needed.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Play ambience. This was MUCH easier than having an extra node be a child to the player.
	ambience.play()
	
# CODE FROM HW6
func _input(event):
	# Get mouse movement.
	if event is InputEventMouseMotion: # Which it IS! See "func _ready():"
		# I'm pretty sure that this is so x & y coordinate of movement is seemless.
		rotate_y(event.relative.x * MOUSE_MOVMENT)
		# I tried the inverse so you could get multiple axies, but it got all wonky.
		# rotate_x(event.relative.y * MOUSE_MOVMENT)
		

func _physics_process(delta):
	
	### THIS STUFF RUNS EVERY FRAME ###
	
	#Play step sound effect if the play moves in any direction.
	# Cut because the execution was awkward. See "CUT CODE" block above for it's function.
	# _stepSFX() 
	
	### START OF TIMER/"FLICKERCLOCK" MECHANICS ###
	# This variable will uptick every frame,
	# and its read value will judge the player at the end of each course.
	FlickerClock += 1 
	# Check to see if flashlight is on. If so, double flicker counter's accumulation.
	if Flashlight.visible:
		# Go up by "1" every frame. This will be used for a flicker effect.
		FlickerClock += 1 
		### CUT SOUND EFFECT MECHANIC (SEE BLOCK AT LINE 49) ###
			# Below are the listed times (per frame) when the flicker sound will play.
			#if FlickerClock == 600: 
				#flicker.play()
				#for reachTimeOut in 30: # Will time out the lights for 30 frames.
						#Flashlight.visible = false
				#Flashlight.visible = true # Turning the flashlight back on after the loop is over.
				#reachTimeOut = 0 # Reset back to zero.
			#if FlickerClock == 1000:
				#flicker.play()
			#if FlickerClock == 1010:
				#flicker.play() 
			#if FlickerClock == 1050: 
				#flicker.play()
	print(FlickerClock) # Originally for debugging purposes, display how much "FLickerCLock" has passed.
	### END OF TIMER/"FLICKERCLOCK" MECHANICS ###
	
	
	### START OF RESET GAME INPUT ###
	# This is a fail-safe to ensure that, if the player gets stuck,
	# they can reset the scene by just pressing "R" for 10 seconds.
	if Input.is_action_pressed("Reset"):
		ResetClock += 1 # Add 1 to the reset clock.
		# Assuming 60 FPS, it'll take 600 frames to reach the 10 second threshold.
		if ResetClock > 600: # Checks clock surpasses 600.
			# Resets the scene.
			get_tree().change_scene_to_file("res://1_aa_Hub.tscn")
			# There is no need to reset the "ResetClock" variable because the scene changes cause it to do that on its own.
	### END OF RESET GAME INPUT ###
	
	
	### START OF FLASHLIGHT MECHANIC ###
	# Turn Flashlight On/OFF by clicking the left button.
	if Input.is_action_just_pressed("Flashlight"): # Check if the flashlight button is pressed.
			# Toggle flashlight. 
			if Flashlight.visible: # Checking if flashlight is visible.
				Flashlight.visible = false # Turning off it's on.
				click.play() # Play FlashlightClick
				# theme.stop() # Flashlight Theme. (See Cut SFX & Music Code Block)
			else: 
				Flashlight.visible = true # Turning on if it's off.
				click.play() # Play FlashlightClick
				# theme.play() # Play FlashlightTheme (See Cut SFX & Music Code Block)
	### END OF FLASHLIGHT MECHANIC ###
	
	### START OF GRAVITY & JUMP APPLICATION ###
	
	# Much of thise is old code from HW6.
	if not is_on_floor(): #Read if player is on the ground.
		velocity.y -= gravity * delta #Brings them down to earth.
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	# This alternate conditional allows multijump. Used for debugging.
	# if Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
	### END OF GRAVITY & JUMP APPLICATION ###

	### START OF MOVEMENT INPUT ###
	
	# A lot of this is from both tutorials and HW6.
	# Get the input direction and handle the movement/deceleration.
	# I know saying "leftward" & "rightward" isn't conventionally correct. TOO BAD! It makes me happy to read it like that.
	# Defines what inputs are labled which.
	var input_dir = Input.get_vector("leftward", "rightward", "forward", "backward") 
	# Assigns inputs respective directions. The "direction" variable is used to read all four.
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() 
	if direction: #Only true if one of the inputs are pressed.
		# Reads direction and translates it into movement.
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		# Slows and stops the player.
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide() #Likely helps prevent the movement from being janky.
	
	### END OF MOVEMENT INPUT ###

#### HUB RING WARPS ####

# WARNING: Each ring's area body has to be manually connected to this script.
# Hub Ring 1 - Leads to Level 1
func _on_warp_area_1_body_entered(body):
	get_tree().change_scene_to_file("res://1_a_Course 1.tscn")
	pass # Replace with function body.

# Hub Ring 2 - Leads to Level 2
func _on_warp_area_2_body_entered(body):
	get_tree().change_scene_to_file("res://1_a_Course 2.tscn")
	pass # Replace with function body.
	

# Hub Ring 3 - Leads to Level 3
func _on_warp_area_3_body_entered(body):
	get_tree().change_scene_to_file("res://1_a_Course 3.tscn")
	pass # Replace with function body.

# Hub Ring 4 - Leads to Level 4
func _on_warp_area_4_body_entered(body):
	get_tree().change_scene_to_file("res://1_a_Course 4.tscn")
	pass # Replace with function body.

# Hub Ring 4 - Leads to Level 5
func _on_warp_area_5_body_entered(body):
	get_tree().change_scene_to_file("res://1_a_Course 5.tscn")
	pass # Replace with function body.

# Hub Ring 6 - Leads to Level 6
func _on_warp_area_6_body_entered(body):
	get_tree().change_scene_to_file("res://1_a_Course 6.tscn")
	pass # Replace with function body.

#### GOAL RING WARPS ####
## (SEE LINES 18, 90, & 128) The variables pertaining to time and flashlight usage will used here.
func _on_warp_goal_body_entered(body):
	# Warps player to the room that shows how well they did.
	
	# This is bad code, but it works.
	# I was going to use switch cases, but my knowledge of "else:if" is more reliable. 
	# Thankfully, it only has to happen upon touching a ring.
	
	if FlickerClock < 3601: # If a minute or less passed.
		get_tree().change_scene_to_file("res://1_a_Rank S.tscn")
	else: if FlickerClock < 7201: # If two minutes or less passed.
		get_tree().change_scene_to_file("res://1_a_Rank A.tscn")
	else: if FlickerClock < 10801: # If three minutes or less passed.
		get_tree().change_scene_to_file("res://1_a_Rank B.tscn")
	else: if FlickerClock < 14401: # If four minutes or less passed.
		get_tree().change_scene_to_file("res://1_a_Rank C.tscn")
	else: #Anything beyond five minutes.
		get_tree().change_scene_to_file("res://1_a_Rank D.tscn")

#### BACK TO HUB WARP ####
# Warps player back to hub.
# Used by all orange rings in their respective scenes.
func _on_warp_hub_body_entered(body):
	get_tree().change_scene_to_file("res://1_aa_Hub.tscn")
	pass # Replace with function body.
