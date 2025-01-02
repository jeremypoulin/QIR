extends Control

@onready var puck = get_parent().get_node("Puck")
@onready var userscore = get_node("UserScore")
@onready var botscore = get_node("BotScore")
func _ready():
	userscore.text = str(Global.user_score)
	botscore.text = str(Global.bot_score)

func _update_user_score():
	userscore.text = str(Global.user_score)
	
func _update_bot_score():
	botscore.text = str(Global.bot_score)
