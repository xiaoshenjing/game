# Godot 4 塔防游戏项目规范

## 0. 开发参考指南

本项目开发时，必须以 **Godot 4.6 官方文档** 为最高参考标准：
- 官方文档地址：https://docs.godotengine.org/en/4.6/

### 0.1 文档参考原则

1. **API 使用规范**：所有节点、类、函数的使用必须遵循官方文档的推荐方式
2. **最佳实践**：优先使用官方文档推荐的实现方式和代码模式
3. **版本兼容性**：确保代码与 Godot 4.6 版本完全兼容
4. **文档查阅**：遇到问题时，优先查阅官方文档而不是第三方教程

### 0.2 官方文档重点参考区域

| 主题 | 文档链接 | 用途 |
|------|---------|------|
| GDScript | https://docs.godotengine.org/en/4.6/tutorials/scripting/gdscript/gdscript_basics.html | 语言特性和最佳实践 |
| 2D 开发 | https://docs.godotengine.org/en/4.6/tutorials/2d/index.html | 2D 游戏开发相关 |
| 输入系统 | https://docs.godotengine.org/en/4.6/tutorials/inputs/index.html | 输入处理规范 |
| 物理系统 | https://docs.godotengine.org/en/4.6/tutorials/physics/index.html | 碰撞和物理 |
| UI 系统 | https://docs.godotengine.org/en/4.6/tutorials/ui/index.html | 界面开发规范 |
| 类参考 | https://docs.godotengine.org/en/4.6/classes/index.html | 所有节点和类的 API |

## 一、命名规范

### 1.1 文件命名

| 文件类型 | 命名规则 | 示例 |
|---------|---------|------|
| 脚本文件 | 小写蛇形命名 | `player_controller.gd`, `tower_base.gd` |
| 场景文件 | 小写蛇形命名 | `main_menu.tscn`, `enemy_orc.tscn` |
| 资源文件 | 小写蛇形命名 | `texture_player.png`, `sound_explosion.wav` |
| 配置文件 | 小写蛇形命名 | `game_config.cfg`, `level_data.json` |

### 1.2 变量命名

| 变量类型 | 命名规则 | 示例 |
|---------|---------|------|
| 普通变量 | 小写蛇形命名 | `player_health`, `tower_damage` |
| 常量 | 全大写蛇形命名 | `MAX_HEALTH`, `DEFAULT_SPEED` |
| 私有变量 | 下划线前缀 + 小写蛇形 | `_internal_state`, `_animation_timer` |
| 导出变量 | 小写蛇形命名（带 @export） | `@export var attack_range: float` |

### 1.3 函数命名

| 函数类型 | 命名规则 | 示例 |
|---------|---------|------|
| 普通函数 | 小写蛇形命名 | `spawn_enemy()`, `calculate_damage()` |
| 私有函数 | 下划线前缀 + 小写蛇形 | `_update_position()`, `_handle_collision()` |
| 信号回调 | 下划线前缀 + on_ + 信号名 | `_on_timer_timeout()`, `_on_body_entered()` |
| Getter/Setter | get_/set_ + 变量名 | `get_health()`, `set_target()` |

### 1.4 节点命名

| 节点类型 | 命名规则 | 示例 |
|---------|---------|------|
| 功能节点 | PascalCase | `PlayerCharacter`, `MainCamera`, `GameUI` |
| 容器节点 | PascalCase | `EnemiesContainer`, `TowerParent` |
| UI 控件 | PascalCase | `HealthBar`, `GoldLabel`, `StartButton` |

### 1.5 信号命名

使用小写蛇形命名，动词开头：
- `enemy_died(reward: int)`
- `tower_placed(position: Vector2)`
- `wave_completed(wave_number: int)`

---

## 二、项目架构规范

### 2.1 目录结构

```
game/
├── Scenes/           # 场景文件
│   ├── UI/           # UI 场景
│   ├── Levels/       # 关卡场景
│   └── Prefabs/      # 预制件场景（敌人、塔等）
├── Scripts/          # 脚本文件
│   ├── UI/           # UI 相关脚本
│   ├── Gameplay/     # 游戏逻辑脚本
│   ├── Managers/     # 管理器脚本
│   └── Utils/        # 工具函数脚本
├── Resources/        # 资源文件
│   ├── Textures/     # 纹理图片
│   ├── Sounds/       # 音效文件
│   └── Data/         # 配置数据
├── Tests/            # 测试文件
│   ├── Unit/         # 单元测试
│   └── Integration/  # 集成测试
└── project.godot     # 项目配置
```

### 2.2 场景化设计原则

1. **单一职责**: 每个场景只负责一个核心功能
2. **可复用性**: 预制件场景应设计为可重复使用
3. **组合优于继承**: 使用节点组合而非脚本继承
4. **信号驱动**: 通过信号实现节点间解耦

### 2.3 组件化设计原则

| 组件类型 | 职责 | 示例 |
|---------|------|------|
| Controller | 控制逻辑 | `PlayerController`, `EnemyAI` |
| Component | 功能组件 | `DamageComponent`, `HealthComponent` |
| Manager | 全局管理 | `GameManager`, `ResourceManager` |
| UI | 界面展示 | `HUD`, `Menu` |

### 2.4 模块化设计原则

1. **高内聚低耦合**: 模块内部紧密相关，模块间依赖最小
2. **接口明确**: 通过信号和导出变量定义清晰接口
3. **依赖注入**: 通过 @export 注入依赖而非硬编码

---

## 三、编码规范

### 3.1 脚本结构

```gdscript
extends Node2D

# 1. 导出变量（配置参数）
@export var speed: float = 100.0
@export var max_health: int = 100

# 2. 私有变量（内部状态）
var _current_health: int = 0
var _is_active: bool = false

# 3. 信号定义
signal health_changed(new_health: int)
signal died()

# 4. 生命周期函数
func _ready():
    _current_health = max_health
    _is_active = true

func _physics_process(delta):
    if _is_active:
        _update_position(delta)

# 5. 公共方法
func take_damage(amount: int):
    _current_health -= amount
    emit_signal("health_changed", _current_health)
    
    if _current_health <= 0:
        _is_active = false
        emit_signal("died")

# 6. 私有方法
func _update_position(delta):
    # 实现移动逻辑
    pass
```

### 3.2 信号使用规范

1. **信号命名**: 使用动词或事件描述命名
2. **参数明确**: 信号参数应清晰说明用途
3. **解耦原则**: 发送者不应知道接收者的实现
4. **连接时机**: 在 _ready() 或初始化时连接

### 3.3 错误处理

```gdscript
# 使用断言进行参数校验
func spawn_enemy(enemy_scene: PackedScene):
    assert(enemy_scene != null, "Enemy scene cannot be null")
    
    var enemy = enemy_scene.instance()
    if not enemy.has_method("set_path"):
        push_warning("Enemy scene does not have set_path method")
        return
    
    add_child(enemy)
```

---

## 四、单元测试规范

### 4.1 测试文件结构

```
Tests/
├── Unit/
│   ├── test_enemy.gd
│   ├── test_tower.gd
│   └── test_game_manager.gd
└── Integration/
    └── test_combat.gd
```

### 4.2 测试类命名

| 类型 | 命名规则 | 示例 |
|-----|---------|------|
| 测试脚本 | test_ + 被测模块名 | `test_enemy.gd` |
| 测试函数 | test_ + 测试场景 | `test_take_damage()` |

### 4.3 测试用例结构

```gdscript
extends TestCase

# 前置条件
func setup():
    # 在每个测试前执行
    pass

# 后置条件
func teardown():
    # 在每个测试后执行
    pass

# 测试用例
func test_enemy_take_damage():
    # 1. 准备
    var enemy = Enemy.new()
    enemy.max_health = 100
    
    # 2. 执行
    enemy.take_damage(30)
    
    # 3. 断言
    assert_equal(enemy.health, 70)

func test_enemy_death():
    var enemy = Enemy.new()
    enemy.max_health = 50
    
    var death_signal = false
    enemy.connect("died", func(): death_signal = true)
    
    enemy.take_damage(60)
    
    assert_true(death_signal)
    assert_false(enemy.is_active)
```

### 4.4 测试覆盖要求

| 测试类型 | 覆盖要求 |
|---------|---------|
| 单元测试 | 核心逻辑 100% 覆盖 |
| 集成测试 | 关键流程覆盖 |
| 边界测试 | 边界条件覆盖 |

### 4.5 测试运行规范

1. **测试时机**: 每次代码提交前运行单元测试
2. **测试结果**: 所有测试必须通过
3. **测试报告**: 保存测试结果供审查

---

## 五、Godot 特定规范

### 5.0 官方文档优先

所有 Godot 相关代码必须严格遵循 Godot 4.6 官方文档的推荐方式：
- 官方文档地址：https://docs.godotengine.org/en/4.6/
- 类参考地址：https://docs.godotengine.org/en/4.6/classes/index.html

在编写代码前，务必查阅：
1. 对应类的官方文档，了解其推荐使用方式
2. 相关教程和最佳实践
3. 版本兼容性说明，确保代码在 Godot 4.6 中正常工作

### 5.1 节点树组织

```
MainScene
├── Camera2D (命名: MainCamera)
├── Player (命名: PlayerCharacter)
│   ├── Sprite2D
│   ├── CollisionShape2D
│   └── PlayerController (脚本)
├── Enemies (命名: EnemiesContainer)
│   └── Enemy1, Enemy2, ...
└── UI (命名: GameUI)
    ├── HealthBar
    └── GoldLabel
```

### 5.2 碰撞层约定

| 层号 | 名称 | 用途 |
|-----|------|------|
| 1 | Player | 玩家角色 |
| 2 | Enemy | 敌人 |
| 3 | Tower | 防御塔 |
| 4 | Bullet | 子弹/投射物 |
| 5 | Obstacle | 障碍物 |
| 6 | UI | UI 元素 |

### 5.3 导出变量规范

```gdscript
# 导出变量应包含默认值和类型注解
@export var speed: float = 100.0
@export var health: int = 100
@export var target_scene: PackedScene

# 使用 @onready 延迟初始化
@onready var _sprite = $Sprite2D
@onready var _collision = $CollisionShape2D
```

### 5.4 资源管理

1. **资源路径**: 使用 `res://` 绝对路径
2. **资源加载**: 使用 `preload()` 或 `load()`
3. **资源缓存**: 避免重复加载相同资源

---

## 六、代码审查检查清单

- [ ] 命名符合规范
- [ ] 代码结构清晰
- [ ] 信号使用正确
- [ ] 错误处理完善
- [ ] 单元测试覆盖
- [ ] 性能考虑
- [ ] 注释充分
- [ ] 代码遵循 Godot 4.6 官方文档推荐方式
- [ ] 所有 API 使用符合官方文档规范
- [ ] 代码与 Godot 4.6 版本兼容
- [ ] 已查阅相关官方文档确认实现方式

---

## 七、持续集成要求

1. **自动构建**: 每次提交触发构建
2. **自动测试**: 构建成功后运行测试
3. **代码质量**: 检查代码风格和规范
4. **部署流程**: 测试通过后部署到测试环境

---

## 附录：常用设计模式

### 单例模式（管理器）
```gdscript
# GameManager.gd
extends Node

var _instance: GameManager = null

static func get_instance() -> GameManager:
    return _instance

func _ready():
    if _instance == null:
        _instance = self
        set_process_priority(100)
    else:
        queue_free()
```

### 工厂模式（对象创建）
```gdscript
# EnemyFactory.gd
extends Node

@export var enemy_types: Dictionary = {
    "orc": preload("res://Scenes/enemy_orc.tscn"),
    "goblin": preload("res://Scenes/enemy_goblin.tscn")
}

func create_enemy(type_name: String) -> Node2D:
    if enemy_types.has(type_name):
        return enemy_types[type_name].instance()
    return null
```

### 观察者模式（信号系统）
```gdscript
# 使用 Godot 内置信号系统实现观察者模式
signal wave_started(wave: int)
signal wave_completed(wave: int)
```