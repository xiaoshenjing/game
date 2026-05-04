## [Core] 状态基类
##
## 所有具体状态节点必须继承此类，并按需重写 enter/exit/update/physics_update。
##
## 依赖：StateMachine（由状态机在 _ready 时注入）

class_name State
extends Node

# ---- 变量 ----

## 所属状态机的引用（由 StateMachine 自动注入）
var state_machine: Node = null

# ---- 需子类重写的方法 ----

## 进入此状态时调用。
func enter() -> void:
	pass

## 离开此状态时调用。
func exit() -> void:
	pass

## 每帧调用（等同 _process）。
## [param delta] 帧时间间隔（秒）
func update(_delta: float) -> void:
	pass

## 每物理帧调用（等同 _physics_process）。
## [param delta] 物理帧时间间隔（秒）
func physics_update(_delta: float) -> void:
	pass
