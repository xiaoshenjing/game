## [Managers] 游戏全局管理器
##
## 负责管理游戏整体状态（运行、暂停、结束），
## 是各系统的核心协调节点，通过信号驱动其他模块响应状态变化。
##
## 依赖：无（作为 Autoload 最先加载）

extends Node

# ---- 枚举 ----

## 游戏状态枚举
enum GameState {
	MAIN_MENU,  ## 主菜单
	PLAYING,    ## 游戏进行中
	PAUSED,     ## 暂停
	GAME_OVER,  ## 游戏结束
}

# ---- 信号 ----

## 游戏状态发生变化时触发。
## [param new_state] 变化后的游戏状态
signal game_state_changed(new_state: GameState)

## 游戏暂停时触发。
signal game_paused()

## 游戏恢复时触发。
signal game_resumed()

# ---- 私有变量 ----

var _current_state: GameState = GameState.MAIN_MENU

# ---- 公共方法 ----

## 切换到指定游戏状态。
## [param new_state] 目标状态
func change_state(new_state: GameState) -> void:
	if _current_state == new_state:
		return
	_current_state = new_state
	game_state_changed.emit(new_state)

## 返回当前游戏状态。
func get_state() -> GameState:
	return _current_state

## 暂停游戏。
func pause_game() -> void:
	get_tree().paused = true
	change_state(GameState.PAUSED)
	game_paused.emit()

## 恢复游戏。
func resume_game() -> void:
	get_tree().paused = false
	change_state(GameState.PLAYING)
	game_resumed.emit()

## 结束游戏并返回主菜单。
func quit_to_main_menu() -> void:
	get_tree().paused = false
	change_state(GameState.MAIN_MENU)
	# TODO: 加载主菜单场景
