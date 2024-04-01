extends Node2D

class_name draw_throw_line

#投げる方向を描画します
#このスクリプトで何か質問、エラーがあれば櫻井にいってください

var start:Vector2=Vector2.ZERO
var end:Vector2=Vector2.ZERO
#var color:Color=Color(0,0,0)
var color:bool=true
var width:float=1.0
var img
const yazirushi_ob = preload("res://Scene/Player/yazirushi.tscn")
const yazirushi_img = preload("res://Resources/yazirushi.png")
const yazirushi_color_img = preload("res://Resources/yazirushi_color.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	#矢印画像の生成
	img=yazirushi_ob.instantiate()
	add_child(img)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	#draw_line(start, end, color,width)
	#渡された情報から三角形を描画します
	#画像に差し替え
	#var points = PackedVector2Array()
	#var d=(end-start).normalized()
	#points.append(end)	
	#points.append(start+Vector2(d.y,-d.x)*width/2)
	#points.append(start+Vector2(-d.y,d.x)*width/2)
	#draw_polygon(points,PackedColorArray([Color(0,0,0)]))
	pass

func set_value(start_point:Vector2=self.start,end_point:Vector2=self.end,color:bool=self.color,width:float=self.width):
	start=start_point
	end=end_point
	self.color=color
	self.width=width
	#queue_redraw()
	
	#ここから矢印画像にするための変更
	var d=(end-start)
	img.position=start_point
	img.rotation=d.normalized().angle()
	img.scale=Vector2(d.length()/566.0,width/358.0)
	img.get_node("tex").texture=yazirushi_color_img if color else yazirushi_img
	
	pass
