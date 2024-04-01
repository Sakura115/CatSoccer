extends Button

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

signal mode_change(i:int)

var mode=0 #現在のモード

var sButton_tex : Array #PackedStringArray #ボタンを押したときに切り替えるテクスチャ
var skill_N:int

# Called when the node enters the scene tree for the first time.
func _ready():
	self.focus_mode = FOCUS_NONE
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_value(tex : Array,skill_num:int):
	sButton_tex=tex
	skill_N=skill_num
	#print("set")
	pass

func _on_pressed():
	mode+=1
	mode=mode%skill_N
	get_parent().texture=sButton_tex[mode%sButton_tex.size()]
	print("moodChange")
	emit_signal("mode_change",mode)
	pass
