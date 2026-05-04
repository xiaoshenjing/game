## [Entities] 玩家控制器
##
## 处理玩家输入、移动与动画，是玩家角色的主要驱动脚本。
## 游戏逻辑（如扣血、得分）通过信号传递给 GameManager，不在此处直接修改全局状态。
##
## 依赖：GameManager（监听暂停信号）

class_name PlayerController
extends CharacterBody2D

# ---- 导出变量 ----

## 水平移动速度（像素/秒）
@export var move_speed: float = 200.0

## 跳跃初速度（像素/秒，负值向上）
@export var jump_velocity: float = -400.0

# ---- 常量 ----

## 重力加速度，与项目物理设置保持一致
const GRAVITY: float = 980.0

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
	_apply_gravity(delta)
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

# 应用重力，离地时增加下落速度
func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

# 读取输入并更新水平速度与跳跃
func _handle_movement() -> void:
	var direction := Input.get_axis("left", "right")
	velocity.x = direction * move_speed
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
	# 翻转精灵朝向
	if direction != 0:
		_sprite.flip_h = direction < 0

# 生命值归零后的处理逻辑
func _on_health_depleted() -> void:
	player_died.emit()
	# TODO: 播放死亡动画，延迟后通知 GameManager

# 连接信号
func _connect_signals() -> void:
	pass
