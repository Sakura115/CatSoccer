extends "./PlayerState.gd" #ファイルを移動したときにエラーにならないように相対パスにさせてもらいました(櫻井)

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

class_name PlayerThrowState
var throw_input_posi = Vector2.ZERO #ドラック入力開始地点
var Dividing_factor = 0.5#ドラック距離を力に変換するときの除算係数

var throw_line #投げる方向を描写するノード
var line_MaxWidth:float #線の太さ上限
var line_MinWidth:float #線の太さ下限
#var line_color:Color #線の色
#var line_color_error:Color #外側に打とうとしている時の線の色
var line_MaxLength:float #線の長さ上限
var line_MinLength:float #線の長さ下限

var maxForce_circle #ドラック時に力の最大値を表示する円を描写するノード

var mouse_circle #ドラック時にマウスの位置に円を描画するノード
var circle_MaxR=80 #半径の太さ上限
var circle_MinR=1 #半径の太さ下限
var circle_color=Color(255,255,255,0.8)

func _init(player:Player, stateMachine:PlayerStateMachine, anim:String):
	super._init(player, stateMachine, anim)

func _Enter():
	super._Enter()
	_player.isThrowing = true
	
	# 入力開始時(ドラック開始時)にマウスの座標を記録
	throw_input_posi = _player.get_global_mouse_position()
	#print("始点:" + str(throw_input_posi))
	
	line_MaxWidth=100
	line_MinWidth=1
	#line_color=Color(255,255,255,0.8)
	#line_color_error=Color(255,0,0,0.8)
	line_MinLength=50 
	line_MaxLength=250
	
	circle_MaxR=100
	circle_MinR=1
	circle_color=Color(255,255,255,0.8)
	
	var main = "/root/Main"
	throw_line= draw_throw_line.new()
	throw_line.name="throw_line"
	_player.add_child(throw_line)
	throw_line.set_value(_player.throw_slipper_posi,_player.throw_slipper_posi,true,line_MinWidth)
	
	maxForce_circle=draw_maxForce_circle.new()
	maxForce_circle.name="maxForce_circle"
	_player.add_child_avoid_error(maxForce_circle,main)
	maxForce_circle.set_value(throw_input_posi,_player.throw_MaxForce*Dividing_factor,Color(255,255,255,0.5),5)
	
	mouse_circle=throw_mouseCircle.new()
	mouse_circle.name="mouse_circle"
	_player.add_child_avoid_error(mouse_circle,main)
	mouse_circle.set_value(throw_input_posi,circle_MinR,circle_color)

func _process(delta):
	super._process(delta)
	if not _player.canThrow:
		_stateMachine.ChangeState(_player.idleState)
	else:
		var mouse_posi = _player.get_global_mouse_position()
		var force = (mouse_posi - throw_input_posi).length()/Dividing_factor #マウスをドラックした距離から力を計算する
		var direction = -(mouse_posi - throw_input_posi).normalized() #マウスをドラックした角度から投げる方向を決める(パチンコのように移動した方向と逆)
		
		force = clamp(force, 0.1, _player.throw_MaxForce) #力が大きくなりすぎないようにする
		
		#投げる方向の描画
		var line_width=force/_player.throw_MaxForce*(line_MaxWidth-line_MinWidth)+line_MinWidth #0~maxForceの値をline_MinWidth~line_MaxWidthにする
		var line_length=force/_player.throw_MaxForce*(line_MaxLength-line_MinLength)+line_MinLength #0~maxForceの値をline_MinLength~line_MaxLengthにする
		if (_player.leftP && direction.x>0)||(!_player.leftP && direction.x<0):
			throw_line.set_value(_player.throw_slipper_posi,direction*line_length,true,line_width)
		else:
			throw_line.set_value(_player.throw_slipper_posi,direction*line_length,false,line_width)
		
		
		#マウス位置に描画する円
		var circle_R=force/_player.throw_MaxForce*(circle_MaxR-circle_MinR)+circle_MinR #0~maxForceの値をcircleの上限下限にする
		var mouse_circle_posi=mouse_posi
		if mouse_circle_posi.distance_to(throw_input_posi)>(_player.throw_MaxForce*Dividing_factor):
			mouse_circle_posi=throw_input_posi+(mouse_posi-throw_input_posi).normalized()*_player.throw_MaxForce*Dividing_factor
		#mouse_circle_posi.x = clamp(mouse_posi.x,(throw_input_posi.x-_player.throw_MaxForce*Dividing_factor),(throw_input_posi.x+_player.throw_MaxForce*Dividing_factor))
		#mouse_circle_posi.y = clamp(mouse_posi.y,(throw_input_posi.y-_player.throw_MaxForce*Dividing_factor),(throw_input_posi.y+_player.throw_MaxForce*Dividing_factor))
		mouse_circle.set_value(mouse_circle_posi,circle_R)
		
		#投げる処理
		if _player.isThrowing && Input.is_action_just_released("mouse_left"):
			# ドラッグ終了時(ボタンを離したとき)
			
			#画面の内側にしか投げられないようにする
			if (_player.leftP && direction.x>0)||(!_player.leftP && direction.x<0): #左プレイヤーの時は右方向に、右プレイヤーの時は左方向にしか投げない
				_player.throw(_player.throw_slipper_type, force, direction)
				_player.canThrow = false #入力を終わりにする
				
			else: #画面の外側に投げようとしている時、入力をキャンセルする
				_player.canThrow = false
				
			#_player.throw(_player.throw_slipper_ob, force, direction)
			
	pass

func start_input()->bool: #NPCを作るために開始の判定を移動しました
	#スペースキーなどを押しているうえでマウスボタンを押したときに(ドラック開始時)した時に投げられるようにする
	#ただマウスをドラックしたときにするとマウスでボタンを押したときなどにも反応すると思うのでスペースキーと同時押しにしました
	if  Input.is_action_pressed("throw_start"): #throw_Count < throw_MaxN
		if Input.is_action_just_pressed("throw"):
			return true
	else: #マウスのボタンを離すより先にスペースキーが離されたとき入力をキャンセルする
		return false
	return _player.canThrow
	pass

func _Exit():
	super._Exit()
	_player.isThrowing = false
	maxForce_circle.queue_free()
	throw_line.queue_free()
	mouse_circle.queue_free()
	#print(_player.throw_Count)
