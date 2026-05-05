## [UI] 设置菜单控制器
##
## 提供语言切换功能。当前支持：中文（zh）/ English（en）。
## 语言切换通过 TranslationServer.set_locale() 完成，并自动持久化。
##
## 依赖：RunManager

extends Control

# ---- 节点引用 ----

@onready var _title: Label = $Mask/UI_Pop/Label_Title
@onready var _lang_label: Label = $Mask/UI_Pop/Hor/Label_Tip
@onready var _btn_zh: Button = $Mask/UI_Pop/Hor/Btn_ZH
@onready var _btn_en: Button = $Mask/UI_Pop/Hor/Btn_EN
@onready var _btn_back: Button = $Mask/UI_Pop/Btn_Claimed

# ---- 生命周期 ----

func _ready() -> void:
	_connect_signals()
	_refresh_ui()

# ---- 私有方法 ----

# 连接所有按钮信号
func _connect_signals() -> void:
	_btn_zh.pressed.connect(_on_btn_zh_pressed)
	_btn_en.pressed.connect(_on_btn_en_pressed)
	_btn_back.pressed.connect(_on_btn_back_pressed)

# 刷新所有文本（支持语言切换后立刻更新）
func _refresh_ui() -> void:
	_title.text = tr("OPTIONS_TITLE")
	_lang_label.text = tr("OPTIONS_LANGUAGE")
	_btn_zh.text = tr("OPTIONS_LANG_ZH")
	_btn_en.text = tr("OPTIONS_LANG_EN")
	_btn_back.text = tr("OPTIONS_BACK")
	_update_lang_buttons()

# 根据当前语言更新按钮选中状态
func _update_lang_buttons() -> void:
	var cur = TranslationServer.get_locale()
	_btn_zh.disabled = (cur == "zh")
	_btn_en.disabled = (cur == "en")

# ---- 信号回调 ----

func _on_btn_zh_pressed() -> void:
	TranslationServer.set_locale("zh")
	_refresh_ui()

func _on_btn_en_pressed() -> void:
	TranslationServer.set_locale("en")
	_refresh_ui()

func _on_btn_back_pressed() -> void:
	RunManager.load_scene(RunManager.SceneType.MAIN_MENU)
