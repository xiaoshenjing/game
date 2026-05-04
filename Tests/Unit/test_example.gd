## [Tests/Unit] 单元测试示例
##
## 演示单元测试的基本写法，实际测试请参照此格式编写。
## 测试文件命名规范：test_<模块名>.gd
##
## 依赖：GUT 框架（如未安装请先在 addons 中安装）

extends GutTest

# ---- 测试用例 ----

## 测试示例：验证基础断言写法是否正常。
func test_example_assert() -> void:
	assert_eq(1 + 1, 2, "1 + 1 应等于 2")

## 测试示例：验证字符串拼接。
func test_string_concat() -> void:
	var result := "Hello" + " " + "World"
	assert_eq(result, "Hello World", "字符串拼接结果不正确")
