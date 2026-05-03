# 命运圣契 (Fate Testament) — 项目规范

Godot 4.6 卡牌 roguelike 项目。参考文档：https://docs.godotengine.org/en/4.6/

---

## 命名规范

| 类型 | 规则 | 示例 |
|-----|------|------|
| GDScript 文件 | `snake_case` | `card_base.gd`, `battle_manager.gd` |
| 场景文件 | `snake_case` | `battle_scene.tscn`, `card_widget.tscn` |
| 资源文件 | `snake_case` | `icon_heart.png`, `sfx_card_flip.wav` |
| 类名/节点名 | `PascalCase` | `BattleManager`, `CardWidget`, `RouletteWheel` |
| 变量 | `snake_case` | `player_health`, `current_hand_size` |
| 常量 | `UPPER_SNAKE` | `MAX_HAND_SIZE`, `DEFAULT_ENERGY` |
| 私有成员 | `_snake_case` | `_selected_cards`, `_is_animating` |
| 信号 | `snake_case` 动词开头 | `card_played(card)`, `turn_ended()` |
| 信号回调 | `_on_` + 信号名 | `_on_card_played(card)` |

---

## 目录结构

```
game/
├── Scenes/
│   ├── Battle/          # 对战场景（轮盘、槽位、手牌区）
│   ├── UI/              # 菜单、HUD、结算界面
│   └── Prefabs/         # 可复用组件（卡牌、敌人、槽位）
├── Scripts/
│   ├── Core/            # 核心系统（卡牌、轮盘、战斗流程）
│   ├── Data/            # 数据定义（52张牌、敌人、符文配置）
│   ├── UI/              # UI 控制器
│   └── Managers/        # 全局管理器（存档、音频、事件）
├── Resources/
│   ├── Cards/           # 卡牌美术资源
│   ├── Audio/           # 音效与音乐
│   └── Data/            # JSON/Resource 配置文件
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
BattleManager.card_played.emit(card_data)
# ❌ 错误
get_node("/root/UI").update_hand()
```

### 数据与表现分离
- `Scripts/Data/` 定义纯数据结构（CardData, EnemyData, RuneData）
- `Scripts/Core/` 处理游戏逻辑，不直接操作 UI
- `Scripts/UI/` 只负责展示，通过信号接收数据变化

### 组合优于继承
```gdscript
# ✅ 用组件组合
@export var damage_component: DamageComponent
@export var status_component: StatusComponent

# ❌ 深层继承链
extends Card > extends AttackCard > extends ContractCard
```

---

## 核心系统约定

### 卡牌系统
- 52 张牌以 `CardData` Resource 定义，包含：id, suit, rank, effect_type, value, cost, rarity
- 花色枚举：`SPADE(♠)`, `HEART(♥)`, `DIAMOND(♦)`, `CLUB(♣)`
- 稀有度枚举：`COMMON`, `RARE`, `EPIC`, `LEGENDARY`

### 轮盘系统
- 6 槽位，槽位效果枚举：`POWER`, `GUARD`, `AMPLIFY`, `HEAL`, `CURSE`, `FURY`
- 先手判定含连续保护（连抢先手 2 次 → 下回合强制后手）

### 战斗流程
- 状态机驱动：`SETUP → PLAYER_TURN → ENEMY_TURN → REVEAL → RESOLVE → CLEANUP`
- 每阶段有明确的进入/退出信号

---

## 代码风格

```gdscript
extends Node

# 1. @export 导出变量
@export var max_hand_size: int = 8
@export var card_scene: PackedScene

# 2. @onready 延迟引用
@onready var _hand_container = $HandContainer
@onready var _roulette = $RouletteWheel

# 3. 信号
signal card_selected(card_data: CardData)
signal turn_confirmed()

# 4. 私有变量
var _selected_indices: Array[int] = []
var _is_animating: bool = false

func _ready():
    _connect_signals()

func select_card(index: int) -> void:
    if _is_animating:
        return
    _selected_indices.append(index)
    card_selected.emit(_hand[index])

func _connect_signals() -> void:
    _roulette.slot_clicked.connect(_on_slot_clicked)
```

- 参数校验用 `assert()`，可恢复错误用 `push_warning()`
- 动画期间用 `_is_animating` 锁防止重复输入
- 避免 `$` 动态路径，用 `@onready` 缓存节点引用

---

## 测试要求

- 核心逻辑（伤害计算、组合判定、诅咒结算）必须有单元测试
- 测试文件命名：`test_` + 模块名（`test_card_combo.gd`）
- 每次提交前运行全部测试

---

## 禁止事项

- 禁止在 UI 脚本中写游戏逻辑
- 禁止硬编码卡牌数值（统一从 Data 配置读取）
- 禁止使用 `get_node("../../../")` 跨层级引用
- 禁止在 `_process` 中做非帧相关计算
