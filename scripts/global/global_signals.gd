extends Node

# Interface
signal incrase_points(amount: int)

# Player
signal attack_player(damage: float)
signal restore_player_health(health: float)
signal player_attack(damage: float)

# Audio
signal play_final_level01_audio()
signal play_level01_audio()

func _ready() -> void:
	emit_signal("attack_player", 0.0)
	emit_signal("restore_player_health", 0.0)
	emit_signal("player_attack", 0.0)
