extends Control

## This is the GUI for the energy station.

var energy_station : EnergyStation = null
@export var description_label : Label
@export var ttf_label : Label
@export var progress_bar : ProgressBar

func _process(_delta):
	if energy_station != null and visible:
		progress_bar.value = energy_station.get_battery().value
		ttf_label.text = str("Time to fill: ", roundi(energy_station.get_battery().get_time_to_fill()), "s")
		
	

func _on_energy_station_gui_changed_energy_station(new_energy_station):
	energy_station = new_energy_station
	description_label.text = str("Charging at: ", energy_station.get_battery().growth_per_second, "/s", "\n", "Capacity: ", energy_station.get_battery().maximum_value, "kWh\n")
	