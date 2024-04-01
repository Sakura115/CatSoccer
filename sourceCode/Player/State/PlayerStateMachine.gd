extends Node
class_name PlayerStateMachine

@export var currentState : PlayerState:
	set(val):
		currentState = val
	get:
		return currentState

func Initialize(startState : PlayerState) -> void:
	currentState = startState
	currentState._Enter()

func ChangeState(newState : PlayerState) -> void:
	currentState._Exit()
	currentState = newState;
	currentState._Enter()
