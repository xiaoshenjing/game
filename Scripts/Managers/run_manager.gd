## [Managers] 关卡/流程运行管理器
##
## 负责关卡切换、场景加载与卸载，统一管理游戏运行流程。
## 所有场景跳转必须经由此管理器执行，禁止直接调用 SceneTree 切换场景。
##
## 依赖：GameManager（监听游戏状态信号）

extends Node

# ---- 常量 ----

## 主菜单场景路径
const MAIN_MENU_SCENE: String = "res://Scenes/UI/main_menu.tscn"

# ---- 信号 ----

## 场景开始加载时触发。
## [param scene_path] 目标场景路径
signal scene_load_started(scene_path: String)

## 场景加载完成时触发。
## [param scene_path] 已加载的场景路径
signal scene_load_finished(scene_path: String)

# ---- 私有变量 ----

# 当前已加载的场景路径
var _current_scene_path: String = ""

# ---- 生命周期 ----

func _ready() -> void:
	_connect_signals()

# ---- 公共方法 ----

## 切换到指定场景（淡出 → 加载 → 淡入）。
## [param scene_path] 目标场景的资源路径
func load_scene(scene_path: String) -> void:
	if scene_path.is_empty():
		push_warning("RunManager: scene_path 不能为空")
		return
	scene_load_started.emit(scene_path)
	_current_scene_path = scene_path
	get_tree().change_scene_to_file(scene_path)
	scene_load_finished.emit(scene_path)

## 返回当前场景路径。
func get_current_scene_path() -> String:
	return _current_scene_path

# ---- 私有方法 ----

# 连接外部信号
func _connect_signals() -> void:
	GameManager.game_state_changed.connect(_on_game_state_changed)

# 响应游戏状态变化，执行对应场景跳转
func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	if new_state == GameManager.GameState.MAIN_MENU:
		load_scene(MAIN_MENU_SCENE)
