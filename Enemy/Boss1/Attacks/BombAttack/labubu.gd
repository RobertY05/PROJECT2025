extends Area2D

#Editable Stats and stuff
@export var damage := 20.0
@export var knockback := 200.0
@export var fuse_time := 1
@export var explosion_duration := 0.5

#Important Variables for display
var exploded := false
var warningSprite: Sprite2D
var explosionSprite: Sprite2D

#On start only show the warning image
func _ready():
	warningSprite = $WarningSprite
	warningSprite.visible = true
	
	explosionSprite = $LabubuExplosion
	explosionSprite.visible = false
	
	#Run timer then blow up
	await get_tree().create_timer(fuse_time).timeout
	explode()

func explode():
	#Make sure they only blow up onces
	if exploded:
		return
	exploded = true
	
	#Swap Sprites
	if warningSprite:
		warningSprite.visible = false
	explosionSprite.visible = true
	
	#Check for collision and take damage only once
	for body in get_overlapping_bodies():
		if body is Actor and body.friendly:
			var dir = (body.global_position - global_position).normalized()
			body.hurt(damage, dir * knockback)
			print("ouch")
	
	#Wait for the bombs to finish blowing up then delete their node
	await get_tree().create_timer(explosion_duration).timeout
	queue_free()
