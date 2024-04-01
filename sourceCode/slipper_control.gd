extends Node2D

#このスクリプトで何か質問、エラーがあれば櫻井にいってください
#スリッパの作り方が私の想定と違うようなのでそれぞれのスリッパごとに処理を変えられるようにしました
#以下のthrow_slipperの中身を書き換えて対応させてください
#shotgunはプレイヤーのほうですでに複数回投げる処理をしているので投げる回数は一回でいいです

@export var LeftPlayerPath = "../L_Player"
@export var RightPlayerPath = "../R_Player"

@export var slipper_type:PackedStringArray #プレイヤーから渡されるスリッパタイプの名前
@export var slipper_ob:Array #上の配列に対応したスリッパオブジェクト

var R_slipper:Array
var L_slipper:Array
var L_MaxNum
var R_MaxNum
var screenSize

# Called when the node enters the scene tree for the first time.
func _ready():
	var L_Player
	if has_node(LeftPlayerPath):
		L_Player=get_node(LeftPlayerPath)
		L_Player.throw_slipper.connect(L_throw_slipper)
		L_MaxNum = L_Player.slipper_MaxNum
	else:
		L_MaxNum=3
	
	var R_Player
	if has_node(RightPlayerPath):
		R_Player=get_node(RightPlayerPath)
		R_Player.throw_slipper.connect(R_throw_slipper)
		R_MaxNum = R_Player.slipper_MaxNum
	else:
		R_MaxNum=3
	
	R_slipper = []
	L_slipper = []
	screenSize=get_viewport_rect().size
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func slipper_object_search(type:String)->int: #配列から同じ名前を探し出してidを返す
	for i in range(slipper_type.size()):
		if type==slipper_type[i]:
			return i
	return -1
	pass

func throw_slipper(type:String,force:float,direction:Vector2,posi:Vector2,left:bool):
	var id=slipper_object_search(type)
	#それぞれに対応したものを書く
	match id:
		0,1,2,3:#nomal,heavy,shotgun,curve
			#スリッパの生成
			var slipper=slipper_ob[id %slipper_ob.size()].instantiate()
			add_child(slipper)
			slipper.global_position=posi
			if left:
				for child in slipper.get_children():
					#Sprite2Dノードを見つけた場合
					if child is Sprite2D:
						child.scale*=Vector2(-1,1)
			#slipper.thrown(force,false,direction)
			slipper.set_value(force,direction)
			return slipper
		_:
			print("エラー")
			return null
	
	pass

func L_throw_slipper(type:String,force:float,direction:Vector2,posi:Vector2):
	var slipper=throw_slipper(type,force,direction,posi,true)
	if slipper != null:
		slipper.name="L_slipper"+str(L_slipper.size())
		L_slipper.append(slipper)
		
		if L_slipper.size()>L_MaxNum:
			slipper_delete(L_slipper,0)
			reName(L_slipper,"L_slipper")
	pass

func R_throw_slipper(type:String,force:float,direction:Vector2,posi:Vector2):
	var slipper=throw_slipper(type,force,direction,posi,false)
	if slipper!=null:
		slipper.name="R_slipper"+str(R_slipper.size())
		R_slipper.append(slipper)
		
		if R_slipper.size()>R_MaxNum:
			slipper_delete(R_slipper,0)
			reName(R_slipper,"R_slipper")
	pass

func reName(a:Array,n:String):
	for i in range(a.size()):
		a[i].name=(n+str(i))
		#print(str(i)+":"+a[i].name)
	pass

func slipper_delete(a:Array,deleteID:int):
	a[deleteID].name="delete" #名前を変えないとreNameがうまく動かないので名前を変える
	a[deleteID].queue_free()
	a.remove_at(deleteID)
	pass
