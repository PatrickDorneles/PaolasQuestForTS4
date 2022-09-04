extends Node

var coins: int = 0

signal coins_updated(new_actual, modification)

func add_coins(amount: int):
	coins += amount
	emit_signal("coins_updated", coins, amount)
