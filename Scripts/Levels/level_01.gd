## [Levels] 关卡01控制器
##
## 处理关卡01的UI交互逻辑。
##
## 依赖：RunManager

extends Node2D

# ---- 节点引用 ----

@onready var _btn_back: Button = $UI/Btn_Back
@onready var _lbl_back: Label = $UI/Btn_Back/Label_Back

# ---- 生命周期 ----

func _ready() -> void:
	_connect_signals()
	_refresh_ui()

# ---- 私有方法 ----

# 连接按钮信号
func _connect_signals() -> void:
	_btn_back.pressed.connect(_on_back_pressed)

# 刷新所有文本
func _refresh_ui() -> void:
	_lbl_back.text = tr("OPTIONS_BACK")

# ---- 信号回调 ----

func _on_back_pressed() -> void:
	GameManager.quit_to_main_menu()
