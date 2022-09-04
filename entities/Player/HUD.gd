extends CanvasLayer

onready var player: Player = get_parent()
onready var status = get_node("../PlayerStatus")
onready var inventory = get_node("../Inventory")
onready var health_bar = $HealthBar

func _ready():
	health_bar.show()
	health_bar.max_value = status.max_health_points
	
	$Coins/CoinLabel.text = $Coins/CoinLabel.text % inventory.coins
	$Lifes/LifeLabel.text = $Lifes/LifeLabel.text % Gamestate.tries


func on_update_health(amount_health: int):
	health_bar.value = amount_health

func _on_Inventory_coins_updated(new_actual, modification):
	$Coins/CoinLabel.text = str(int($Coins/CoinLabel.text) + modification)
