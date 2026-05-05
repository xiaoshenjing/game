## [Entities] 玩家控制器
##
## 处理玩家输入、移动与动画，是玩家角色的主要驱动脚本。
## 游戏逻辑（如扣血、得分）通过信号传递给 GameManager，不在此处直接修改全局状态。
##
## 依赖：GameManager（监听暂停信号）

class_name PlayerController
extends CharacterBody2D

# ---- 导出变量 ----

## 移动速度（像素/秒）
@export var move_speed: float = 200.0

# ---- 节点引用 ----

@onready var _anim: AnimationPlayer = $AnimationPlayer
@onready var _sprite: Sprite2D = $Sprite2D

# ---- 信号 ----

## 玩家死亡时触发。
signal player_died()

## 玩家生命值变化时触发。
## [param new_value] 变化后的生命值
## [param max_value] 最大生命值
signal health_changed(new_value: int, max_value: int)

# ---- 私有变量 ----

# 当前生命值
var _health: int = 100

# 最大生命值
var _max_health: int = 100

# 是否处于无敌帧
var _is_invincible: bool = false

# ---- 生命周期 ----

func _ready() -> void:
	_connect_signals()

func _physics_process(delta: float) -> void:
	_handle_movement()
	move_and_slide()

# ---- 公共方法 ----

## 对玩家造成指定数值的伤害，无敌帧期间无效。
## [param amount] 伤害数值（需大于 0）
func take_damage(amount: int) -> void:
	if amount <= 0 or _is_invincible:
		return
	_health = max(0, _health - amount)
	health_changed.emit(_health, _max_health)
	if _health == 0:
		_on_health_depleted()

# ---- 私有方法 ----

# 读取输入并更新移动
func _handle_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	velocity = direction * move_speed
	# 翻转精灵朝向
	if direction.x != 0:
		_sprite.flip_h = direction.x < 0

# 生命值归零后的处理逻辑
func _on_health_depleted() -> void:
	player_died.emit()
	# TODO: 播放死亡动画，延迟后通知 GameManager

# 连接信号
func _connect_signals() -> void:
	pass
