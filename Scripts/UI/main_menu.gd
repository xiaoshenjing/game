## [UI] 主菜单控制器
##
## 处理主菜单三个按钮：开始游戏、设置、退出。
## 所有文本通过 tr() 获取，支持语言实时切换刷新。
##
## 依赖：GameManager、RunManager

extends Control

# ---- 节点引用 ----

@onready var _btn_start: Button = $Start
@onready var _btn_option: Button = $Option
@onready var _btn_quit: Button = $Quit

# ---- 生命周期 ----

func _ready() -> void:
	_connect_signals()
	_refresh_ui()

# ---- 私有方法 ----

# 连接按钮信号
func _connect_signals() -> void:
	_btn_start.pressed.connect(_on_start_pressed)
	_btn_option.pressed.connect(_on_option_pressed)
	_btn_quit.pressed.connect(_on_quit_pressed)

# 刷新所有文本
func _refresh_ui() -> void:
	_btn_start.text = tr("BTN_START")
	_btn_option.text = tr("BTN_OPTIONS")
	_btn_quit.text = tr("BTN_QUIT")

# ---- 信号回调 ----

func _on_start_pressed() -> void:
	GameManager.change_state(GameManager.GameState.PLAYING)

func _on_option_pressed() -> void:
	RunManager.load_scene(RunManager.SCENE_OPTIONS_MENU)

func _on_quit_pressed() -> void:
	get_tree().quit()
