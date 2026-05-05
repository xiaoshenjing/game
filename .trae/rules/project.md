# Godot 游戏项目规范

Godot 4.x 游戏项目。参考文档：https://docs.godotengine.org/en/stable/

---

## 命名规范

| 类型 | 规则 | 示例 |
|-----|------|------|
| GDScript 文件 | `snake_case` | `player.gd`, `game_manager.gd` |
| 场景文件 | `snake_case` | `main.tscn`, `player.tscn` |
| 资源文件 | `snake_case` | `icon_player.png`, `sfx_jump.wav` |
| 类名/节点名 | `PascalCase` | `GameManager`, `PlayerController` |
| 变量 | `snake_case` | `player_health`, `move_speed` |
| 常量 | `UPPER_SNAKE` | `MAX_HEALTH`, `GRAVITY` |
| 私有成员 | `_snake_case` | `_is_dead`, `_input_direction` |
| 信号 | `snake_case` 动词开头 | `player_died()`, `score_changed(value)` |
| 信号回调 | `_on_` + 信号名 | `_on_player_died()`, `_on_score_changed(value)` |

---

## 目录结构

```
game/
├── Scenes/
│   ├── Levels/          # 关卡场景
│   ├── UI/              # 菜单、HUD、弹窗等界面
│   └── Prefabs/         # 可复用预制体（角色、道具、特效等）
├── Scripts/
│   ├── Core/            # 核心系统（输入、物理、状态机等）
│   ├── Entities/        # 游戏实体（玩家、敌人、NPC）
│   ├── UI/              # UI 控制器
│   └── Managers/        # 全局管理器（游戏、音频、存档、事件）
├── Resources/
│   ├── Textures/        # 图片与精灵资源
│   ├── Audio/           # 音效与音乐
│   ├── Fonts/           # 字体资源
│   └── Data/            # JSON/Resource 配置文件
├── addons/              # 第三方插件
└── Tests/
    ├── Unit/            # 单元测试
    └── Integration/     # 集成测试
```

---

## 架构原则

### 信号驱动解耦
模块间通过信号通信，禁止直接调用其他模块的内部方法：
```gdscript
# ✅ 正确
GameManager.player_died.emit()
# ❌ 错误
get_node("/root/UI").show_game_over()
```

### 数据与表现分离
- `Scripts/Managers/` 管理全局状态，不直接操作 UI
- `Scripts/Core/` 处理游戏逻辑，不直接操作 UI
- `Scripts/UI/` 只负责展示，通过信号接收数据变化

### 组合优于继承
```gdscript
# ✅ 用组件组合
@export var health_component: HealthComponent
@export var movement_component: MovementComponent

# ❌ 深层继承链
extends Entity > extends LivingEntity > extends Player
```

### 游戏状态管理规范
- **场景切换必须通过 GameManager.change_state() 驱动**，不要直接调用 RunManager.load_scene()
- **返回主菜单使用 GameManager.quit_to_main_menu()**，确保游戏状态正确重置
- **RunManager 监听 game_state_changed 信号自动执行场景切换**，保持架构解耦
- **GameState 枚举**: MAIN_MENU（主菜单）、PLAYING（游戏中）、PAUSED（暂停）、GAME_OVER（游戏结束）
```gdscript
# ✅ 正确：从游戏返回主菜单
GameManager.quit_to_main_menu()

# ✅ 正确：进入游戏
GameManager.change_state(GameManager.GameState.PLAYING)

# ❌ 错误：直接调用场景管理器
RunManager.load_scene(RunManager.SceneType.MAIN_MENU)
```

### 国际化规范
- **所有显示文本使用 tr() 函数**，支持多语言切换
- **翻译文本统一管理**（Godot 内置翻译系统）
- **不要在代码中硬编码显示文本**
```gdscript
# ✅ 正确
_lbl_start.text = tr("BTN_START")
_btn_back.text = tr("OPTIONS_BACK")

# ❌ 错误
_lbl_start.text = "开始游戏"
_btn_back.text = "返回"
```

---

## 脚本注释规范

### 文件头注释
每个脚本文件顶部必须包含文件头注释，说明该脚本的用途和所属模块：
```gdscript
## [模块名] 简短描述
## 
## 详细说明（可选）：描述脚本的职责、使用方式或注意事项。
## 
## 依赖：列出主要依赖的信号、管理器或组件（可选）
```

### 类/节点注释
公共类使用 `##` 文档注释，私有类/工具类简短说明即可：
```gdscript
## 玩家控制器，负责处理输入并驱动玩家角色移动与动画。
class_name PlayerController
extends CharacterBody2D
```

### 变量注释
导出变量（`@export`）必须加注释说明用途；私有变量若含义不自明也需注释：
```gdscript
## 玩家移动速度（像素/秒）
@export var move_speed: float = 200.0

## 最大生命值
@export var max_health: int = 100

# 当前是否处于无敌帧状态
var _is_invincible: bool = false
```

### 函数注释
公共函数必须使用 `##` 文档注释，私有/辅助函数用 `#` 行注释简述意图：
```gdscript
## 对玩家造成指定数值的伤害，低于 0 时不触发。
## [param amount] 伤害数值
func take_damage(amount: int) -> void:
    if amount <= 0:
        return
    _apply_damage(amount)

# 内部扣血逻辑，触发死亡检测
func _apply_damage(amount: int) -> void:
    health -= amount
    if health <= 0:
        _on_player_died()
```

### 信号注释
信号定义必须注释其触发时机和参数含义：
```gdscript
## 玩家生命值变化时触发。
## [param new_value] 变化后的生命值
## [param old_value] 变化前的生命值
signal health_changed(new_value: int, old_value: int)

## 玩家死亡时触发。
signal player_died()
```

### 内联注释原则
- 注释描述"为什么"，不重复描述代码本身做了"什么"
- 复杂逻辑/算法必须添加说明性注释
- 临时代码、待办事项使用 `# TODO:` 或 `# FIXME:` 标记

```gdscript
# TODO: 后续需要接入动画状态机
velocity = Vector2.ZERO

# FIXME: 边界检测在斜坡上有误差，待修复
if is_on_wall():
    _jump_buffer = 0
```

---

## 代码风格

```gdscript
extends Node

# ---- 导出变量 ----
@export var move_speed: float = 200.0
@export var player_scene: PackedScene

# ---- 节点引用 ----
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _anim: AnimationPlayer = $AnimationPlayer

# ---- 信号 ----
signal player_died()
signal score_changed(value: int)

# ---- 私有变量 ----
var _health: int = 100
var _is_animating: bool = false

func _ready() -> void:
    _connect_signals()

## 公共方法必须有文档注释。
func take_damage(amount: int) -> void:
    _health -= amount
    if _health <= 0:
        player_died.emit()

# 连接信号，集中管理避免遗漏
func _connect_signals() -> void:
    pass
```

- 参数校验用 `assert()`，可恢复错误用 `push_warning()`
- 避免 `$` 动态路径，统一用 `@onready` 缓存节点引用
- 禁止在 `_process` 中做与帧无关的重计算

---

## 测试要求

- 核心逻辑必须有单元测试覆盖
- 测试文件命名：`test_` + 模块名（如 `test_player_health.gd`）
- 每次提交前运行全部测试

---

## 禁止事项

- 禁止在 UI 脚本中写游戏逻辑
- 禁止硬编码数值（统一从 `Resources/Data/` 配置读取）
- 禁止使用 `get_node("../../../")` 跨层级引用
- 禁止在 `_process` 中做非帧相关的重型计算
- 禁止公共函数缺少文档注释（`##`）
