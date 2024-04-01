extends Label

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

@export var ball_name = "ball" #スコア加点のためのボールノードの名前

signal goal

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.L_score=0
	GameManager.R_score=0
	$Right_Player_Score.text=str(GameManager.R_score)
	$Left_Player_Score.text=str(GameManager.L_score)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_goal_left_area_entered(area): 
	#左ゴールにボールが入ったとき右のスコアを加点する
	if(area.name==ball_name):
		GameManager.R_score+=1
		$Right_Player_Score.text=str(GameManager.R_score)
		print("R +1 !!")
		$R_UP.play()
		emit_signal("goal")
	#else:
		#以外の物(スリッパ)の場合消す
		#area.queue_free()
	pass # Replace with function body.


func _on_goal_right_area_entered(area):
	#右ゴールにボールが入ったとき左のスコアを加点する
	if(area.name==ball_name):
		GameManager.L_score+=1
		$Left_Player_Score.text=str(GameManager.L_score)
		print("L +1 !!")
		$L_UP.play()
		emit_signal("goal")
	#else:
		#以外の物(スリッパ)の場合消す
		#area.queue_free()
	pass # Replace with function body.
