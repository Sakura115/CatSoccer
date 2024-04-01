extends Node
class_name PlayerState
var _player : Player
var _stateMachine : PlayerStateMachine
var _anim : String

func _init(player : Player, stateMachine : PlayerStateMachine, anim : String):
	self._player = player
	self._stateMachine = stateMachine
	self._anim = anim

func _Enter():
	#print("I Enter %s State." % _anim)
	pass

func _process(delta):
	#print("I'm in %s State" % _anim)
	pass
	
func _Exit():
	#print("I exit %s State." % _anim)
	pass
