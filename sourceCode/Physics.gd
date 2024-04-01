extends Node2D

class_name  Physics

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

#var collision=false
var force:float = 0
var direction=Vector2.ZERO
var timer=0
@export var weight=10
@export var friction=10
@export var bounce=0.1 #静止しているものとぶつかったときの跳ね返り率

var collision_force:Array
var collision_direction:Array

#動ける範囲
var LeftTop
var RightBottom

var collision_ob #ぶつかったもの 同じものに連続してぶつからないようにする

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Physics")
	self.area_entered.connect(collision)
	LeftTop=get_node_position_avoid_error("/root/Main/left_top_moving_range")
	RightBottom=get_node_position_avoid_error("/root/Main/right_bottom_moving_range")
	
	if RightBottom.x==LeftTop.x:
		LeftTop.x=0
		RightBottom.x=get_viewport_rect().size.x
	if RightBottom.y==LeftTop.y:
		LeftTop.y=0
		RightBottom.y=get_viewport_rect().size.y
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	collision_set()
	timer+=delta
	
	if(collision_ob!=null)&&(timer>0.1):
		collision_ob=null
	
	if(force>0):
		var v=0
		force=force-friction*weight*delta
		if(force<=0):
			force=0
		else:
			v=force/weight
			if v<0 :
				v=0
				force=0
			position+=direction*v
	
	global_position.x=clamp(global_position.x,LeftTop.x,RightBottom.x)
	global_position.y=clamp(global_position.y,LeftTop.y,RightBottom.y)
	pass


func set_value(force:float=self.force,direction:Vector2=self.direction):
	self.collision_force.append(force)
	self.collision_direction.append(direction)
	pass

func reset_value():
	force=0
	direction=Vector2.ZERO
	var num=collision_force.size()
	if num!=0:
		for i in range(num):
			collision_force.remove_at(0)
			collision_direction.remove_at(0)
	pass

func collision(area):
	if area.is_in_group("Physics"): 
		var area_p = area as Physics
		if area_p!=collision_ob:
			collision_ob=area_p
			timer=0
			var set_F=force
			area_p.set_value(set_F,direction)
			#print("hit!!"+str(set_F)+" "+str(direction))
	elif !area.is_in_group("Wall"):
		var cd:Vector2 = global_position-area.global_position
		cd=cd.normalized()
		if cd.x>0:
			direction.x=abs(direction.x)
		else:
			direction.x=-abs(direction.x)
			
		if cd.y>0:
			direction.y=abs(direction.y)
		else:
			direction.y=-abs(direction.y)
		#print("hit!!"+area.name+str(cd))
	pass

func get_node_position_avoid_error(path:String) -> Vector2: #ノードがなくエラーが起きる対策。返すものはpathのノードのposition
	if has_node(path):
		#print(get_node(path).position)
		return get_node(path).global_position
	else:
		print(path+" が見つかりません。(0,0)にしました")
		return Vector2.ZERO
	pass

func collision_set(): #ぶつかったときの値セット
	var num=collision_force.size()
	#衝突して受け取ったものから今と違う方向の数値を優先的に受け取る
	if num!=0:
		var f=0
		var d=direction
		for i in range(num):
			#print(str(i)+" "+str(collision_force[0])+str(collision_direction[0]))
			if(collision_force[0]==0):#ぶつかったものが静止していた時少し跳ね返るようにする
				f=force*bounce
				d=direction*-1
			else:
				f=collision_force[0]
				if collision_direction[0].x!=direction.x:
					d.x=collision_direction[0].x
					#print(str(i)+"x!")
				if collision_direction[0].y!=direction.y:
					d.y=collision_direction[0].y
					#print(str(i)+"y!")
			collision_force.remove_at(0)
			collision_direction.remove_at(0)
		force=f
		direction=d
		#print(str(force)+str(direction))
	pass
