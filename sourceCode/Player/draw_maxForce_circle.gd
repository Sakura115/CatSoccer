extends Node2D

class_name draw_maxForce_circle

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

var step = 40
var center:Vector2=Vector2.ZERO
var radius:float=1.0
var color:Color=Color(0,0,0)
var width:float=1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _draw():
	#線で円を描画する
	var points = []
	for i in range(step):
		var angle = i * 2.0/step * PI
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		points.append(Vector2(x, y))
		
	for i in range(points.size()):
		draw_line(points[i], points[(i + 1)%points.size()], color,width)
	pass

func set_value(center:Vector2=self.center,radius:float=self.radius,color:Color=self.color,width:float=self.width,step:int=self.step):
	self.center=center
	self.radius=radius
	self.color=color
	self.width=width
	self.step=step
	queue_redraw()
	pass
