extends Node2D

#このスクリプトで何か質問、エラーがあれば櫻井にいってください

signal game_start

var turn = true #true左 false右

const Powerful = preload("res://Scene/Player/Powerful_Cat.tscn")
const Wizard = preload("res://Scene/Player/Wizard_Cat.tscn")
const Shotgun = preload("res://Scene/Player/Shotgun_Cat.tscn")

var player_ob:Array

const slipper_control=preload("res://Scene/Slipper/slipper_control.tscn")

var players:Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player_ob=[Powerful,Wizard,Shotgun]
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func turn_change():
	turn=!turn
	
	if !turn: #2人プレイヤーにするときはturnにする
		var Npc=randi_range(0,player_ob.size()-1) #ランダムでNPCを生成します
		playerAdd(player_ob[Npc]) #NPCの生成
		for i in range(players.size()):
			players[i].set_process(true)
		var sc=slipper_control.instantiate()
		get_parent().add_child(sc)
		emit_signal("game_start")
		queue_free()
	
	pass


func _on_Powerful_pressed():
	playerAdd(Powerful)
	pass # Replace with function body.


func _on_Wizard_pressed():
	playerAdd(Wizard)
	pass # Replace with function body.



func _on_Shotgun_pressed():
	playerAdd(Shotgun)
	pass # Replace with function body.

func playerAdd(player_ob:Object):#プレイヤーを生成します
	var player = player_ob.instantiate()
	get_parent().add_child(player)
	player.set_process(false)
	players.append(player)
	player.Set_whether_left_player(turn)
	turn_change()
	pass

