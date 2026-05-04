## [Core] 主场景控制器
##
## 游戏主入口场景的控制脚本，负责初始化各系统并启动游戏流程。
## 本脚本不处理具体的游戏逻辑，仅做启动协调。
##
## 依赖：GameManager、RunManager

extends Node

# ---- 生命周期 ----

func _ready() -> void:
	TranslationServer.set_locale("zh")
	RunManager.load_scene(RunManager.SCENE_MAIN_MENU)

