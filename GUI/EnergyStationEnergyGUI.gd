extends Control

var energy_station : EnergyStation = null
@export var description_label : Label
@export var ttf_label : Label
@export var progress_bar : ProgressBar

func _on_energy_station_gui_changed_energy_station(new_energy_station):
	energy_station = new_energy_station
	description_label.text = str("Charging at: ", energy_station.get_battery().growth_per_second, "/s", "\n", "Capacity: ", energy_station.get_battery().maximum_value, "kWh\n")
	pass # Replace with function body.

func _process(delta):
	if energy_station != null and visible:
		progress_bar.value = energy_station.get_battery().value
		ttf_label.text = str("Time to fill: ", roundi(energy_station.get_battery().get_time_to_fill()), "s")
		
	pass # Replace with function body.
