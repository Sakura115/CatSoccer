extends Area2D

class_name Player

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

#スリッパの作り方が私の想定と違うようなのでそれぞれのスリッパごとに処理を変えられるようにしました
#Slipper_controlのほうで調節してください

signal throw_slipper(type:String,force:float,direction:Vector2,posi:Vector2)

var speed=300
var moving_range =  Vector2.ZERO #プレイヤーが動ける範囲(上,下)
var LR_player_posi =  Vector2.ZERO #左右のプレイヤーの位置(左,右)
var leftP = true #左のプレイヤーかどうか

#スキルに関する変数
var sp_timer=0.0 #ポイント回復用タイマー
var Consumed_sp = 1 #消費スキルポイント
@export var skill_point:int = 4 #スキルポイント
@export var Max_sp:int = 7 #ポイント上限
@export var add_sp_time:float = 5.0 #ポイント回復時間

#var skillButton
#var skillButton_ob=preload("res://Scene/Player/skill_button.tscn")
@export var sButton_parent="/root/Main"
var sButton_Posi = Vector2.ZERO
@export var sButton_tex : Array = [preload("res://Resources/skill_Button/Nomal.PNG")]#PackedStringArray #ボタンを押したときに切り替えるテクスチャ
@export var skill_Consumed_sp : Array = [1]


#状態遷移に関する変数
var _stateMachine : PlayerStateMachine
var idleState : PlayerIdleState
var moveState : PlayerState #PlayerMoveState #NPCのために変更しました
var throwState : PlayerState #PlayerThrowState
var canMove : bool
var canThrow : bool
var isMoving : bool
var isThrowing : bool

#スリッパに関する変数
#@export var slipper_parent="/root/Main" #生成したスリッパの親のノード
var throw_slipper_type #実際に投げるスリッパ
@export var throw_slipper_posi = Vector2(20,0) #スリッパの出現場所(プレイヤーからずらす距離)(左プレイヤー基準)
@export var throw_MaxForce = 400 #投げられる最大威力
@export var slipper_MaxNum=3 #残るスリッパの数

#@export var usually_slipper = preload("res://Scene/Player/slipper_tmp.tscn")

#@export var throw_MaxN = 1 #投げられる回数
#var throw_Count = 0 #投げた数

# Called when the node enters the scene tree for the first time.
func _ready():
	#throw_Count = 0
	var LeftTop=get_node_position_avoid_error(str(get_parent().get_path())+"/left_top_player_posi")
	var RightBottom=get_node_position_avoid_error(str(get_parent().get_path())+"/right_bottom_player_posi")
	moving_range.x = LeftTop.y
	moving_range.y = RightBottom.y
	LR_player_posi.x = LeftTop.x
	LR_player_posi.y = RightBottom.x
	sButton_Posi=get_node_position_avoid_error(str(get_parent().get_path())+"/skillButton_posi")
	if moving_range.x==moving_range.y:
		moving_range.y=get_viewport_rect().size.y
	throw_slipper_type = "Nomal"
	#print("ready")
	#Set_whether_left_player(leftP)
	global_position.y = moving_range.x
	
	isMoving = false
	isThrowing = false
	_stateMachine = PlayerStateMachine.new()
	idleState = PlayerIdleState.new(self, _stateMachine, "Idle")
	moveState = PlayerMoveState.new(self, _stateMachine, "Move")
	throwState = PlayerThrowState.new(self, _stateMachine, "Throw")
	_stateMachine.Initialize(idleState)
	
	if skill_Consumed_sp.size()>0:
		Consumed_sp=skill_Consumed_sp[0]
	
	pass 

func _process(delta):
	CheckActionConditions()
	_stateMachine.currentState._process(delta)
	
	sp_timer+=delta
	var add_SP=int(sp_timer/add_sp_time)
	skill_point+=add_SP
	sp_timer=sp_timer-add_sp_time*add_SP
	


func throw(slipper_ob,force:float=throw_MaxForce,direction:Vector2=Vector2(1,0)): #スリッパを投げる
	#スリッパの生成
	#var slipper = slipper_ob.instantiate()
	
	#投げたプレイヤーに応じてスリッパの名前を変える
	#if leftP:
	#	slipper.name="L_"+slipper.name
	#else:
	#	slipper.name="R_"+slipper.name
	
	#add_child_avoid_error(slipper,slipper_parent)	
	#slipper.thrown(force,curve,direction)
	#slipper.global_position = global_position + throw_slipper_posi
	skill_point-=Consumed_sp
	emit_signal("throw_slipper",slipper_ob,force,direction,global_position + throw_slipper_posi)
	
	print(throw_slipper_type+" 力:" + str(force) + " 方向:" + str(direction.angle()))
	pass

func Set_whether_left_player(left:bool): #このプレイヤーが左プレイヤーかどうか設定
	leftP=left
	#print("set")
	if leftP:
		global_position.x=LR_player_posi.x
		name="L_Player"
		
		moveState = PlayerMoveState.new(self, _stateMachine, "Move")
		throwState = PlayerThrowState.new(self, _stateMachine, "Throw")
		var skillButton_ob=preload("res://Scene/Player/skill_button.tscn")
		
		#スキルボタンの生成
		var skillButton=skillButton_ob.instantiate()
		skillButton.name="skillButton"
		add_child_avoid_error(skillButton,sButton_parent)
		skillButton.global_position=sButton_Posi
		var sb=skillButton.get_node("Button")
		sb.set_value(sButton_tex,skill_Consumed_sp.size())
		sb.mode_change.connect(skill_mode_change)
		
	else:
		global_position.x=LR_player_posi.y
		throw_slipper_posi.x=-1*throw_slipper_posi.x
		name="R_Player"
		
		#右プレイヤーの時、NPCにする
		moveState = NPCMoveState.new(self, _stateMachine, "Move")
		throwState = NPCThrowState.new(self, _stateMachine, "Throw")
		#スキル
		var skill=NPC_skill.new()
		skill.name="NPCskill"
		add_child(skill)
		skill.set_value(sButton_tex,skill_Consumed_sp.size())
		skill.NPC_mode_change.connect(skill_mode_change)
		
	# return self

func slipper_change(slipper_type): #投げるスリッパを変える
	throw_slipper_type = slipper_type
	pass
	



func CheckActionConditions():
	#NPCのために始める判定を各Stateに移しました(櫻井)
	canMove = !isThrowing and moveState.start_input()
	canThrow= skill_point>=Consumed_sp && throwState.start_input()
	pass


func get_node_position_avoid_error(path:String) -> Vector2: #ノードがなくエラーが起きる対策。返すものはpathのノードのglobal_position
	if has_node(path):
		#print(get_node(path).global_position)
		return get_node(path).global_position
	else:
		print(path+" が見つかりません。(0,0)にしました")
		return Vector2.ZERO
	pass

func add_child_avoid_error(child,path:String="/root"): #add_childのエラーよけ
	#設定した親(path)のノードがなかったら単にrootの子供にする
	if has_node(path):
		get_node(path).add_child(child)
	else:
		get_node("/root").add_child(child)
		print(path+" が見つかりません。/root に生成しました")
	pass

func skilleButton_Posi_set_node(node_path:String):
	sButton_Posi=get_node_position_avoid_error(node_path)
	pass

func skilleButton_Posi_set_vector2(posi:Vector2=Vector2.ZERO):
	sButton_Posi=posi
	pass

func skill_mode_change(mode:int):
	#それぞれに対応したものを書く
	match mode:
		0:
			throw_slipper_type="Nomal"
			Consumed_sp=skill_Consumed_sp[0]
		_:
			print("エラー")
	pass

#func throw_slipper_type_set(type:String):
#	throw_slipper_type=type
#	pass
