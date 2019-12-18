extends Path2D

func _ready():
	set_process(true)
	
func _physics_process(delta):
	$Follow.set_offset($Follow.get_offset() + 100 * delta)

