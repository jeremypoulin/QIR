extends Control

@onready var puck = get_parent().get_node("Puck")
@onready var userscore = get_node("UserScore")
@onready var botscore = get_node("BotScore")
@onready var pause_menu: Control = $PauseMenu

var paused = true;

func _ready():
	userscore.text = str(Global.user_score)
	botscore.text = str(Global.bot_score)

func _update_user_score():
	userscore.text = str(Global.user_score)
	
func _update_bot_score():
	botscore.text = str(Global.bot_score)

func _process(delta):
	if(Input.is_action_just_pressed("ui_pause")):
		pauseMenu()
		
func pauseMenu():
	if paused:
		pause_menu.show()
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		Engine.time_scale = 1
	paused = !paused
