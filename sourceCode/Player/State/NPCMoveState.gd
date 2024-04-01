extends "./PlayerState.gd"

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

class_name  NPCMoveState

var target=0
#var target_circle

func _init(player : Player, stateMachine : PlayerStateMachine, anim : String):
	super._init(player, stateMachine, anim)
	#target_circle=throw_mouseCircle.new()
	#target_circle.name="NPC_target"
	#_player.add_child_avoid_error(target_circle,_player.get_parent().get_path())
	#target_circle.set_value(Vector2.ZERO,10)
	
func _Enter():
	super._Enter()
	target_set()
	#target_circle.global_position=Vector2(_player.global_position.x,target)

func _process(delta):
	if not _player.canMove:
		_stateMachine.ChangeState(_player.idleState)
	else:
		#移動処理
		target_set()
		#target_circle.global_position=Vector2(_player.global_position.x,target)
		var velocity=Vector2.ZERO
		
		#入力
		velocity.y=target-_player.global_position.y
		velocity=velocity.normalized()
		
		#移動
		velocity = velocity*_player.speed
		_player.position.y+=velocity.y*delta
		if velocity.y>0:
			_player.global_position.y=clamp(_player.global_position.y,_player.moving_range.x,target)
		else:
			_player.global_position.y=clamp(_player.global_position.y,target,_player.moving_range.y)
		_player.global_position.y=clamp(_player.global_position.y,_player.moving_range.x,_player.moving_range.y)

func start_input()->bool:
	target_set()
	return !finished_moving()
	pass

func target_set():
	var goal_posi=_player.get_node_position_avoid_error("/root/Main/background/Goal_Left")
	var ball_posi=_player.get_node_position_avoid_error("/root/Main/Ball")
	target=ball_posi.y
	if goal_posi.x!=ball_posi.x:
		target=(ball_posi.y-goal_posi.y)/(ball_posi.x-goal_posi.x)*(_player.position.x-goal_posi.x)+goal_posi.y
	target=clamp(target,_player.moving_range.x,_player.moving_range.y)
	pass

func finished_moving()->bool:
	var ans=abs(int(target-_player.global_position.y))<=0
	#print("NM:"+str(ans)+str(abs(int(target-_player.position.y))))
	return ans

func _Exit():
	super._Exit()
