extends Physics

var curve_speed=0.3

func _process(delta):
	if(force>0):
		var r=direction.angle()+rad_to_deg(curve_speed*delta)
		direction=Vector2(cos(r),sin(r))
	
	super._process(delta)
	pass

func collision_set():
	super.collision_set()
	#var r=direction.angle()-rad_to_deg(10)
	#direction=Vector2(cos(r),sin(r))
	pass
