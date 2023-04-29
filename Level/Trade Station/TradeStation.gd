extends InteractableConstruction

func set_gui_owner() -> void:
	print("setting owner as ", self)
	gui.set_trade_station(self);
