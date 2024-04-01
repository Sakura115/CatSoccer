extends Node2D

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

var sp:Array
var Csp:Array

var nomalColor=Color(255,255,255)
var errorColor=Color(255,0,0)

var player
var error=false

# Called when the node enters the scene tree for the first time.
func _ready():
	sp.append($Skill_point)
	sp.append($Skill_point/Skill_point_n)
	sp.append($Skill_point/Skill_point_n/Skill_point_timer)
	Csp.append($Consumed_sp)
	Csp.append($Consumed_sp/Consumed_sp_n)
	
	color_change(sp,nomalColor)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player==null:
		var playerPath=str(get_parent().get_path()) + "/L_Player"
		if has_node(playerPath):
			player=get_node(playerPath)
			print(player)
	else:
		sp[1].text=str(player.skill_point)
		Csp[1].text=str(player.Consumed_sp)
		sp[2].text=str(int(player.sp_timer*10)/10.0)+"/"+str(player.add_sp_time)
		if player.Consumed_sp>player.skill_point && !error:
			error=true
			color_change(sp,errorColor)
		elif player.Consumed_sp<=player.skill_point && error:
			error=false
			color_change(sp,nomalColor)
		
	#$Consumed_sp.add_theme_color_override("font_color",)
	pass

func color_change(label:Array,c:Color):
	for i in range(label.size()):
		label[i].add_theme_color_override("font_color",c)   # 色変更
	pass

