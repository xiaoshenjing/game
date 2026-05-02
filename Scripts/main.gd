extends Node2D

# 拖拽变量
var drag_offset: Vector2i
var is_dragging: bool = false
var win_id: int

# 拖拽：用 _input 收全局输入（Window 上比 _gui_input 更可靠）
func _input(event: InputEvent) -> void:
	# ESC 退出
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		get_tree().quit()
		return

	# 鼠标左键按下 / 松开
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = event.pressed
		if is_dragging:
			# 统一用屏幕坐标：offset = 鼠标屏幕坐标 - 窗口左上角屏幕坐标
			var win_pos: Vector2i = DisplayServer.window_get_position(win_id)
			drag_offset = DisplayServer.mouse_get_position() - win_pos
		return

	# 鼠标移动 → 拖动窗口
	if event is InputEventMouseMotion and is_dragging:
		var mouse_pos: Vector2i = DisplayServer.mouse_get_position()
		DisplayServer.window_set_position(mouse_pos - drag_offset, win_id)
