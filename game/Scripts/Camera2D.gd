extends Camera2D

var zoomfactor:float = 1
var ZoomFactors: Array = [Vector2(1,1), Vector2(2,2), Vector2(4,4), Vector2(6,6), Vector2(8,8)]
var currentZoomFactor = 1

func _unhandled_input(event):
	if event is InputEventMouseButton and event.pressed:
		if (event.button_index == BUTTON_WHEEL_UP):
			#zoomfactor -= 0.01
			if currentZoomFactor > 0:
				currentZoomFactor -= 1
				zoom = ZoomFactors[currentZoomFactor]
		elif (event.button_index == BUTTON_WHEEL_DOWN):
			#zoomfactor += 0.01
			if currentZoomFactor < ZoomFactors.size()-1:
				currentZoomFactor += 1
				zoom = ZoomFactors[currentZoomFactor]
			
