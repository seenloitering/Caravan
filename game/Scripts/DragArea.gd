extends Node2D

export var sizeVector = Vector2()
export var drawOrigin = Vector2()
export var drawEnd = Vector2()

func _draw():
	var rect2 = Rect2(drawOrigin,sizeVector)
	#rect2.end = drawEnd
	
	draw_rect(rect2, Color(Color.gray))