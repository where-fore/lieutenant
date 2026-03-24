extends Label

var base_text:String = "Encounters: "
var score:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_text()
	text = ""
	HudEvents.combat_won.connect(on_combat_won)
	TimingEvents.restart_the_game.connect(on_combat_won)

func update_text() -> void:
	check_score()
	text = base_text + str(score)

func check_score() -> void:
	score = CombatEvents.encounters_defeated_for_scaling

func on_combat_won() -> void:
	update_text.call_deferred()
