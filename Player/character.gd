extends CharacterBody2D

@export var speed = 400
@onready var animated_sprite = $AnimatedSprite2D

@onready var hzAttackArea = $Hurtboxes/AttackHoriz1

# save hurtbox nodes for access later
@onready 
var upAttackCols = [$Hurtboxes/AttackUp1/Frame0,
 					$Hurtboxes/AttackUp1/Frame1,
					$Hurtboxes/AttackUp1/Frame2,
					$Hurtboxes/AttackUp1/Frame3,
					$Hurtboxes/AttackUp1/Frame4,
					$Hurtboxes/AttackUp1/Frame5]
@onready
var dnAttackCols = [$Hurtboxes/AttackDown1/Frame0,
					$Hurtboxes/AttackDown1/Frame1,
					$Hurtboxes/AttackDown1/Frame2,
					$Hurtboxes/AttackDown1/Frame3,
					$Hurtboxes/AttackDown1/Frame4,
					$Hurtboxes/AttackDown1/Frame5]
@onready
var hzAttackCols = [$Hurtboxes/AttackHoriz1/Frame0,
					$Hurtboxes/AttackHoriz1/Frame1,
					$Hurtboxes/AttackHoriz1/Frame2,
					$Hurtboxes/AttackHoriz1/Frame3,
					$Hurtboxes/AttackHoriz1/Frame4,
					$Hurtboxes/AttackHoriz1/Frame5]
# variable to remember the last hurtbox used
# used to turn it off after activating the next one
@onready var lastAttackCol = $Hurtboxes/AttackUp1/Frame0
					
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.play("Idle")

func get_input():
	# get input direction
	var input_direction = Input.get_vector("left", "right", "up", "down")
	# get attack input
	var input_attack = Input.is_action_pressed("attack")
	# set sprite horiz flip
	if (input_direction[0]>0):
		animated_sprite.flip_h = false
		hzAttackArea.flip_h(false)
	elif (input_direction[0]<0):
		animated_sprite.flip_h = true
		hzAttackArea.flip_h(true)
	# attack is highest input priority
	if input_attack:
		# cant move while attacking
		velocity = Vector2(0.0,0.0)
		if input_direction[1] < 0:
			animated_sprite.play("AttackUp1")
		elif input_direction[1] > 0:
			animated_sprite.play("AttackDown1")
		else:
			animated_sprite.play("AttackHoriz1")
	else:
		# set player velocity based on input
		velocity = input_direction * speed
		# change run animation based on movement input
		if (input_direction[0]==0 and input_direction[1]==0):
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("Run")

func _physics_process(delta):
	get_input()
	move_and_slide()#(velocity * delta)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# update hit / hurboxes in sync with animation
func _on_animated_sprite_2d_frame_changed() -> void:
	lastAttackCol.disabled = true
	if(animated_sprite.animation=="AttackHoriz1"):
		lastAttackCol = hzAttackCols[animated_sprite.frame]
	elif(animated_sprite.animation=="AttackUp1"):
		lastAttackCol = upAttackCols[animated_sprite.frame]
	elif(animated_sprite.animation=="AttackDown1"):
		lastAttackCol = dnAttackCols[animated_sprite.frame]
	else:
		return
	lastAttackCol.disabled = false

# apply damage to enemies on hit
func _on_attack_horiz_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(80)
func _on_attack_up_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(80)
func _on_attack_down_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.take_damage(80)
