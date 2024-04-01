extends Area2D

#プレイヤーの機能を作るときにスリッパが必要だったので簡易的に作りました
#このスクリプトで何か質問、エラーがあれば櫻井にいってください
#このスリッパのthrown()関数を用いてプレイヤーから値を渡すようにするので
#スリッパを作る際にはそこを参考にしてください

var force = 400
var timer=0
var weight=10
var move=false
const friction=10
var direction=Vector2(1,0)
var curve=false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if move:
		timer+=delta
		var v=0
		v=force-friction*weight*timer
		if v<0 :
			v=0
			move=false
		
		position+=direction*v

func thrown(throw_force:float,curveSlipper:bool,throw_direction:Vector2):
	force = throw_force
	curve=curveSlipper
	direction=throw_direction
	direction=direction.normalized()
	print("thrown"+str(force)+" curve:"+str(curve)+str(direction))
	move=true
	timer=0
	#return self

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

