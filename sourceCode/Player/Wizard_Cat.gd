extends Player

#このスクリプトで何か質問、エラーがあれば櫻井にいってください


func _ready():
	super._ready()
	#var cButton = curveButton.instantiate()
	#cButton.pressed.connect(curve_change)
	#super.add_child_avoid_error(cButton,"/root/Main")
	#cButton.position=curveButton_Posi
	pass # Replace with function body.



func Set_whether_left_player(left): #左プレイヤーかどうか設定
	super.Set_whether_left_player(left) 
	if leftP:
		$Sprite.scale*=Vector2(-1,1)
		#print("scale")
	
	#  return self 


func skill_mode_change(mode:int):
	#それぞれに対応したものを書く
	match mode:
		0:
			throw_slipper_type="Nomal"
			Consumed_sp=skill_Consumed_sp[0]
		1:
			throw_slipper_type="Curve"
			Consumed_sp=skill_Consumed_sp[1]
		_:
			print("エラー")
	pass
