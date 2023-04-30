extends OverscreenGUI

@export var ttf_label : Label
@export var progress_bar : ProgressBar 

var water_station : WaterStation

func set_water_station(new_water_station : WaterStation) -> void:
	self.water_station = new_water_station
	progress_bar.max_value = water_station.water_inventory.inventory_size

func _process(delta):
	if water_station != null:
		ttf_label.text = str("Time to fill: ",
		str(water_station.get_time_to_fill()) if water_station.get_time_to_fill() > 0 else "FULL",
		"s\nConnected to: ", water_station.chunks.size(), " chunks")
		progress_bar.value = water_station.water_inventory.water_amount
