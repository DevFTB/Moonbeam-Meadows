extends Control

var energy_station : EnergyStation = null

func _on_energy_station_gui_changed_energy_station(new_energy_station):
	energy_station = new_energy_station
	$VBoxContainer/HBoxContainer/Control/VBoxContainer/DescriptionLabel.text = str("Charging at: ", energy_station.get_battery().growth_per_second, "/s", "\n", "Capacity: ", energy_station.get_battery().maximum_value, "kWh") 
	pass # Replace with function body.

func _process(delta):
	if energy_station != null:
		$VBoxContainer/HBoxContainer/ProgressBar.value = energy_station.get_battery().value
	pass # Replace with function body.
