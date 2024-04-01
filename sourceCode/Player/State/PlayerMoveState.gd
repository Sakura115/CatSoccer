extends "./PlayerState.gd" #ファイルを移動したときにエラーにならないように相対パスにさせてもらいました(櫻井)

class_name  PlayerMoveState

func _process(delta):
	super._process(delta)
	if not _player.canMove:
		_stateMachine.ChangeState(_player.idleState)
	else:	
		#移動処理
		var velocity=0
		
		#プレイヤーの入力
		if Input.is_action_pressed("down"):
			velocity+=1
		if Input.is_action_pressed("up"):
			velocity-=1
		
		#プレイヤーの移動
		velocity = velocity*_player.speed
		_player.position.y+=velocity*delta
		_player.global_position.y=clamp(_player.global_position.y,_player.moving_range.x,_player.moving_range.y)

func start_input()->bool:
	return (Input.is_action_pressed("down") or Input.is_action_pressed("up"))
	pass

