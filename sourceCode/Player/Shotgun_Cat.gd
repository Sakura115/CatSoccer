extends Player

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

@export var Slipper_ang = [Vector2(1,1),Vector2(0,0),Vector2(-1,1)]

func _ready():
	super._ready()
	pass # Replace with function body.

func _process(delta):
	super._process(delta)

func throw(slipper_ob,force:float=throw_MaxForce,direction:Vector2=Vector2(1,0)): #スリッパを投げる
	
	if(throw_slipper_type=="Shotgun"):
		#保存されている角度の数だけスリッパを投げる
		var tmpSP=skill_point #スキルポイントの保存
		for i in range(Slipper_ang.size()): #親のthrowを保存されている角度の数呼び出して、角度を計算して投げる
			var dir_tmp = direction.normalized()+Slipper_ang[i].normalized()
			super.throw(slipper_ob,force,(dir_tmp))
		skill_point=tmpSP - Consumed_sp #過剰に消費されたスキルポイントを元に戻し、正規の数引く
	else:
		super.throw(slipper_ob,force,direction)
	pass

func Set_whether_left_player(left): #左プレイヤーかどうか設定
	super.Set_whether_left_player(left)
	if leftP:
		$Sprite.scale*=Vector2(-1,1)
	#return self


func skill_mode_change(mode:int):
	#それぞれに対応したものを書く
	match mode:
		0:
			throw_slipper_type="Nomal"
			Consumed_sp=skill_Consumed_sp[0]
		1:
			throw_slipper_type="Shotgun"
			Consumed_sp=skill_Consumed_sp[1]
		_:
			print("エラー")
	pass

