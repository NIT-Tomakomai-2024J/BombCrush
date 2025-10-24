extends AbstractFallingObject

func _ready() -> void:
	plane.existingMedalsAmount += 1
func _falling():
	print("Falling...")
	plane.existingMedalsAmount -= 1
	visible = false
	if plane.game_play:
		plane.medalAmount += 1
		plane.medalDropCount += 1
		$AudioStreamPlayer3D.play()
		await $AudioStreamPlayer3D.finished
	queue_free()
