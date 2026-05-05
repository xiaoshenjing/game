## [Managers] 场景路由管理器
##
## 负责所有场景的切换与加载，是唯一允许调用 SceneTree 切换场景的地方。
## 路由规则：监听 GameManager.game_state_changed 信号，根据新状态自动跳转对应场景。
##
## 业务代码只需调用 GameManager.change_state()，无需直接操作本管理器。
##
## 依赖：GameManager（监听 game_state_changed 信号）

extends Node

# ---- 场景路径对象常量（所有路由在此集中维护）----

const SceneType = {
	MAIN_MENU = "res://Scenes/UI/main_menu.tscn",
	LEVEL_01 = "res://Scenes/Levels/level_01.tscn",
	GAME_OVER = "res://Scenes/UI/game_over.tscn",
	OPTIONS_MENU = "res://Scenes/UI/options_menu.tscn"
}

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
	call_deferred("_change_scene", scene_path)

func _change_scene(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)
	scene_load_finished.emit(scene_path)

## 返回当前场景路径。
func get_current_scene_path() -> String:
	return _current_scene_path

# ---- 私有方法 ----

# 连接外部信号
func _connect_signals() -> void:
	GameManager.game_state_changed.connect(_on_game_state_changed)

# 路由表：GameState → 对应场景路径，所有路由规则集中在此维护
func _on_game_state_changed(new_state: GameManager.GameState) -> void:
	match new_state:
		GameManager.GameState.MAIN_MENU:
			load_scene(SceneType.MAIN_MENU)
		GameManager.GameState.PLAYING:
			load_scene(SceneType.LEVEL_01)
		GameManager.GameState.GAME_OVER:
			load_scene(SceneType.GAME_OVER)
		GameManager.GameState.PAUSED:
			# 暂停不切换场景，由 UI 层叠加暂停菜单覆盖
			pass
