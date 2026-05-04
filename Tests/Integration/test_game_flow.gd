## [Tests/Integration] 游戏流程集成测试示例
##
## 测试跨模块的游戏流程，如状态切换是否正确触发信号。
## 集成测试文件命名规范：test_<流程名>.gd
##
## 依赖：GUT 框架、GameManager Autoload

extends GutTest

# ---- 测试用例 ----

## 测试游戏状态从 MAIN_MENU 切换到 PLAYING 时信号是否正确触发。
func test_game_state_change_emits_signal() -> void:
	# FIXME: 需要在 GUT 环境下正确引用 Autoload，待完善
	pass
