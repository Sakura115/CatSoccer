extends "./PlayerState.gd"

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

class_name  NPCThrowState

var throw_Maxtime:float=5 #投げる間隔(秒)
var throw_Mintime:float=0.5 #投げる間隔(秒)
var throw_time:float=0 #投げる間隔(秒)
var time_num=0 #簡易的なミリ秒の計算のための回数記憶
var Dtime:float =0#簡易的なミリ秒の計算のためのデルタ時間記憶変数
var timer

func _init(player:Player, stateMachine:PlayerStateMachine, anim:String):
	super._init(player, stateMachine, anim)
	timer=Time.get_datetime_dict_from_system()
	time_num=0
	Dtime=0
	print("!!")
	#timer.second-=throw_time/2 #始めは早めに投げられるようにする

func _process(delta):
	if not _player.canThrow:
		_stateMachine.ChangeState(_player.idleState)
	else:
		Dtime=delta
		throw()
	pass

func start_input()->bool:
	time_num+=1
	var time=time_difference(timer)+ ((Dtime*time_num)-int(Dtime*time_num))
	#print(time)
	#print(throw_time)
	if time>=throw_time: #||(_player.moveState.finished_moving()):
		return true
	return false

func throw():	
	_player.isThrowing = true
	
	var ball_posi=_player.get_node_position_avoid_error("/root/Main/Ball")
	var direction=ball_posi-_player.global_position
	var force=clamp(direction.length(),0.1,_player.throw_MaxForce)
	direction=direction.normalized()
	_player.throw(_player.throw_slipper_type, force, direction)
	_player.canThrow=false
	_player.isThrowing = false
	timer=Time.get_datetime_dict_from_system()
	time_num=0
	throw_time=randf_range(throw_Mintime,throw_Maxtime)
	print("NPC Throw "+str(throw_time))
	pass

#時間の差を計算する(秒)
func time_difference(befortime,aftertime=Time.get_datetime_dict_from_system())->int:
	var ans
	var day:Array = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31] #月ごとの日にち
	
	if (befortime.year%4== 0) && !((befortime.year%100==0) || (befortime.year%400 != 0)):
		#うるう年のとき二月を29日にする
		day[1] = 29
	
	#print(befortime)
	#print(aftertime)
	ans=aftertime.year-befortime.year
	ans=aftertime.month-befortime.month + ans*12
	ans=aftertime.day-befortime.day + ans*day[befortime.month-1]
	ans=aftertime.hour-befortime.hour + ans*24
	ans=aftertime.minute-befortime.minute + ans*60
	ans=aftertime.second-befortime.second + ans*60
	return ans
