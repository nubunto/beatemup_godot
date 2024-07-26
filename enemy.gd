extends CharacterBody2D
#
#var hitbox_hit := false
#
#func _on_hitbox_area_entered(area):
	#hitbox_hit = true
#
#func _on_range_area_entered(area):
	#if hitbox_hit:
		#print('hurting!')
		#hitbox_hit = false

func take_hit():
	queue_free()
