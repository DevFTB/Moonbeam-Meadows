extends QuestReward
class_name CurrencyQuestReward

@export var currency_reward : int

func _init(p_currency_reward = 5):
	currency_reward = p_currency_reward
	pass

func apply_rewards(level: Level, _player: Player):
	level.get_node("CurrencyManager").add_currency(currency_reward)
	pass
