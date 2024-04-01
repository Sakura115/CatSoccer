extends Node2D

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

class_name throw_mouseCircle

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
	draw_circle(center,radius,color)
	pass

func set_value(center:Vector2=self.center,radius:float=self.radius,color:Color=self.color):
	self.center=center
	self.radius=radius
	self.color=color
	queue_redraw()
	pass
