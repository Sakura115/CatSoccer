extends Player

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

func _ready():
	super._ready()
	pass # Replace with function body.

func _process(delta):
	super._process(delta)

func Set_whether_left_player(left): #左プレイヤーかどうか設定
	super.Set_whether_left_player(left)	
	#return self

func skill_mode_change(mode:int):
	#それぞれに対応したものを書く
	match mode:
		0:
			throw_slipper_type="Nomal"
			Consumed_sp=skill_Consumed_sp[0]
		1:
			throw_slipper_type="Heavy"
			Consumed_sp=skill_Consumed_sp[1]
		_:
			print("エラー")
	pass

