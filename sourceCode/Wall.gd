extends Area2D

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

@export var collision_direction=Vector2.ZERO #当たったものを跳ね返らせる方向(0だと何もしない)

#var size #コリジョンのサイズ
#var c_posi #コリジョンの位置

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Wall")
	self.area_entered.connect(collision)
	#for child in get_children():
		# CollisionShape2Dノードを見つけた場合
		#if child is CollisionShape2D:
			# 相手のCollisionShape2Dのサイズを取得
		#	size = child.shape.size
		#	c_posi = child.position
		#	print(size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func collision(area):
	if area.is_in_group("Physics"):
		var area_p = area as Physics
		var set_F=area_p.force
		if set_F<=0: #力が0以下だと動かない(壁の中から出ていかない)ので力を加える
			set_F=0.1
		var set_D=area_p.direction
		if collision_direction.x!=0:
			set_D.x=abs(set_D.x)*collision_direction.x
		if collision_direction.y!=0:
			set_D.y=abs(set_D.y)*collision_direction.y
		#print("hit!!"+name+str(area_p.direction)+str(set_D)+str(set_F))
		area_p.set_value(set_F,set_D)
	pass

