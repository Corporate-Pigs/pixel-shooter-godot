extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_despawners_body_entered(body: Node2D) -> void:
	if body is Projectile:
		body.hit()
	body.queue_free()
