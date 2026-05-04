## [Managers] 国际化/本地化管理器
##
## 负责游戏语言切换与文本翻译，封装 Godot 内置 TranslationServer。
## 所有 UI 文本必须通过 tr() 获取，禁止硬编码中文/英文字符串。
##
## 依赖：无

extends Node

# ---- 常量 ----

## 支持的语言列表（ISO 639-1 代码）
const SUPPORTED_LOCALES: Array[String] = ["zh_CN", "en"]

## 默认语言
const DEFAULT_LOCALE: String = "zh_CN"

# ---- 信号 ----

## 语言切换完成时触发。
## [param locale] 切换后的语言代码
signal locale_changed(locale: String)

# ---- 私有变量 ----

# 当前语言代码
var _current_locale: String = DEFAULT_LOCALE

# ---- 生命周期 ----

func _ready() -> void:
	# 初始化语言设置（读取存档或使用默认值）
	_apply_locale(DEFAULT_LOCALE)

# ---- 公共方法 ----

## 切换游戏语言。
## [param locale] 目标语言代码，需在 SUPPORTED_LOCALES 中
func set_locale(locale: String) -> void:
	if locale not in SUPPORTED_LOCALES:
		push_warning("I18nManager: 不支持的语言代码 '%s'" % locale)
		return
	_apply_locale(locale)

## 返回当前语言代码。
func get_locale() -> String:
	return _current_locale

# ---- 私有方法 ----

# 应用语言设置并通知监听者
func _apply_locale(locale: String) -> void:
	_current_locale = locale
	TranslationServer.set_locale(locale)
	locale_changed.emit(locale)
