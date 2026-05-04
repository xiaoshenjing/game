## [UI] HUD（游戏内抬头显示）
##
## 展示游戏进行中的实时信息（生命值、分数等）。
## 本脚本只负责 UI 更新，禁止在此处写任何游戏逻辑。
##
## 依赖：PlayerController（监听 health_changed 信号）

extends CanvasLayer

# ---- 节点引用 ----

@onready var _health_bar: ProgressBar = $HealthBar
@onready var _score_label: Label = $ScoreLabel

# ---- 私有变量 ----

# 当前分数
var _score: int = 0

# ---- 生命周期 ----

func _ready() -> void:
	_connect_signals()

# ---- 公共方法 ----

## 更新分数显示。
## [param value] 新的分数值
func update_score(value: int) -> void:
	_score = value
	_score_label.text = str(_score)

# ---- 信号回调 ----

# 玩家生命值变化时更新血条
func _on_health_changed(new_value: int, max_value: int) -> void:
	_health_bar.max_value = max_value
	_health_bar.value = new_value

# ---- 私有方法 ----

# 连接信号（玩家节点在场景树中存在后连接）
func _connect_signals() -> void:
	pass
	# TODO: 获取玩家节点后连接 health_changed 信号
	# player.health_changed.connect(_on_health_changed)
