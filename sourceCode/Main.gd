extends Node2D

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

@export var play_time:float = 60.0 #プレイ時間(秒)
var timer=0
var start=false
@export var nomal_color=Color(1,1,1)
@export var limit_color=Color(1,0,0)

var ball_posi
var ball

var center_circle
var center_circle_size
var center_circle_rotate
var center_slipper:Array=[]

func _ready():
	$timer.text=time_change(play_time)
	$timer.add_theme_color_override("font_color",nomal_color)   # 色変更
	if has_node("Ball"):
		#print(get_node(path).global_position)
		ball=get_node("Ball")
		ball=ball as Physics
		ball_posi = ball.global_position
	else:
		print("Ball が見つかりません")
	
	for child in $background/center_circle.get_children():
		#CollisionShape2Dノードを見つけた場合
		if child is CollisionShape2D:
			center_circle=child
			center_circle_size = child.shape.get_rect().size
			center_circle_rotate = child.global_rotation
			print(center_circle_size)
			print (center_circle_rotate)
			
	$Play_music.play()
	pass
	
func _process(delta):
	if start:
		timer+=delta
		$timer.text=time_change(play_time-int((timer)*10)/10.0)
		if timer>play_time*9/10:
			$timer.add_theme_color_override("font_color",limit_color)   # 色変更
		if play_time<timer:
			get_tree().change_scene_to_file("res://Scene/result_menu/result_menu.tscn")
		
	if (!$Play_music.playing):
		$Play_music.play()
	pass

func time_change(time)->String:
	var m=int(time/60)
	var s=time-m*60
	if m>0:
		return str(m)+"m"+str(s)+"s"
	return str(s)+"s"
	pass


func out_of_centerArea(ob): #センターサークルからobを追い出す
	if center_circle!=null:
		var d=(ob.global_position-center_circle.global_position).normalized()
		var r = (d.angle()-center_circle_rotate)
		var posi=Vector2(cos(r),sin(r)).normalized()
		posi=Vector2(d.x*center_circle_size.x,d.y*center_circle_size.y/2)
		ob.global_position=center_circle.global_position+posi.length()*d
	pass

func _on_player_selection_menu_game_start():
	start=true
	print("\ngame Start!!\n")
	pass # Replace with function body.


func _on_score_goal():
	if ball!=null:
		#ボールをスタート地点に戻す
		ball.position=ball_posi
		ball.reset_value()
		
		#センターサークルからスリッパを追い出す
		var i=0
		for t in range(center_slipper.size()):
			if(center_slipper[i]==null):
				#配列のスリッパの中身がなかったら配列から消す
				#print(i)
				center_slipper.remove_at(i)
				i-=1
			else:
				#中身があったらセンターサークルから追い出す
				out_of_centerArea(center_slipper[i])
			i+=1
			#print(center_slipper.size())
		
	pass # Replace with function body.


func _on_center_circle_area_entered(area):
	center_slipper.append(area)
	#print(area)
	pass # Replace with function body.


func _on_center_circle_area_exited(area):
	#print(area)
	for i in range(center_slipper.size()):
		if(area==center_slipper[i]):
			center_slipper.remove_at(i)
			return
	print(str(area)+"が配列にありません")
	
	pass # Replace with function body.


func _on_ball_area_entered(area):
	$ball_SE.play()
	pass # Replace with function body.
