extends Node2D

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

class_name NPC_skill

signal NPC_mode_change(i:int)

var mode=0 #現在のモード

var sButton_tex : Array #PackedStringArray #ボタンを押したときに切り替えるテクスチャ
var skill_N:int

var change_time:float=5
var timer:float=0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer+=delta
	if timer>change_time:
		timer=0
		skill_mode_change()
	pass

func set_value(tex : Array,skill_num:int):
	sButton_tex=tex
	skill_N=skill_num	
	timer=0
	#print("set")
	pass

func skill_mode_change():
	mode=randi_range(1,skill_N)
	mode=mode%skill_N
	#print("NPCmoodChange")
	emit_signal("NPC_mode_change",mode)
	pass
