extends "./PlayerState.gd" #ファイルを移動したときにエラーにならないように相対パスにさせてもらいました(櫻井)

class_name PlayerIdleState
func _init(player:Player, stateMachine : PlayerStateMachine, anim:String):
	super._init(player, stateMachine, anim)
	pass

func _Enter():
	super._Enter()
	pass

func _process(delta):
	super._process(delta)
	# 移動入力
	if _player.canMove:
		_stateMachine.ChangeState(_player.moveState)
	
	# 投げる入力
	if _player.canThrow:
		_stateMachine.ChangeState(_player.throwState)
	pass


func _Exit():
	super._Exit()
	pass
