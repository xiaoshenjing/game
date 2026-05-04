## [Core] 主场景控制器
##
## 游戏主入口场景的控制脚本，负责初始化各系统并启动游戏流程。
## 本脚本不处理具体的游戏逻辑，仅做启动协调。
##
## 依赖：GameManager、RunManager

extends Node

# ---- 生命周期 ----

func _ready() -> void:
	_start_game()

# ---- 私有方法 ----

# 启动游戏，切换到 PLAYING 状态
func _start_game() -> void:
	GameManager.change_state(GameManager.GameState.MAIN_MENU)
	# TODO: 加载第一关场景
	# RunManager.load_scene("res://Scenes/Levels/level_01.tscn")
