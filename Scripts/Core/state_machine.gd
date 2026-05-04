## [Core] 通用有限状态机
##
## 基于节点的轻量状态机，通过子节点作为状态来管理对象行为。
## 每个状态是一个继承自 State 的节点，挂载在使用者节点下。
##
## 使用方式：
##   1. 将此脚本挂载到父节点的 StateMachine 子节点
##   2. 在 StateMachine 下添加各状态节点（继承 state.gd）
##   3. 调用 transition_to(state_name) 切换状态

extends Node

## 状态机所属的宿主节点（自动指向父节点）
@export var host: Node

# ---- 信号 ----

## 状态切换完成时触发。
## [param from_state] 切换前的状态名
## [param to_state]   切换后的状态名
signal state_changed(from_state: String, to_state: String)

# ---- 私有变量 ----

# 当前激活的状态节点
var _current_state: Node = null

# 所有注册的状态（名称 → 节点）
var _states: Dictionary = {}

# ---- 生命周期 ----

func _ready() -> void:
	host = get_parent()
	# 收集所有子状态节点
	for child in get_children():
		_states[child.name] = child
		child.state_machine = self
	# 激活第一个子节点作为初始状态
	if get_child_count() > 0:
		_current_state = get_child(0)
		_current_state.enter()

func _process(delta: float) -> void:
	if _current_state:
		_current_state.update(delta)

func _physics_process(delta: float) -> void:
	if _current_state:
		_current_state.physics_update(delta)

# ---- 公共方法 ----

## 切换到目标状态。
## [param state_name] 目标状态节点的名称
func transition_to(state_name: String) -> void:
	if not _states.has(state_name):
		push_warning("StateMachine: 未找到状态 '%s'" % state_name)
		return
	var from_name := _current_state.name if _current_state else ""
	if _current_state:
		_current_state.exit()
	_current_state = _states[state_name]
	_current_state.enter()
	state_changed.emit(from_name, state_name)

## 返回当前状态名称。
func get_current_state_name() -> String:
	return _current_state.name if _current_state else ""
