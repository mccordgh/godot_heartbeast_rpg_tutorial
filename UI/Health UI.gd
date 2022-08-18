extends Control


const HEART_SIZE = 15


var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts


onready var hearts_empty = $"Heart UI Empty"
onready var hearts_full = $"Heart UI Full"


func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	if hearts_full != null:
		hearts_full.rect_size.x = hearts * HEART_SIZE
		
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	self.hearts = min(hearts, max_hearts)
	
	if hearts_empty != null:
		hearts_empty.rect_size.x = max_hearts * HEART_SIZE
	
	
func _ready():
	self.max_hearts = PlayersStats.max_health
	self.hearts = PlayersStats.health
	
# warning-ignore:return_value_discarded
	PlayersStats.connect("health_changed", self, "set_hearts")
# warning-ignore:return_value_discarded
	PlayersStats.connect("max_health_changed", self, "set_max_hearts")
	
