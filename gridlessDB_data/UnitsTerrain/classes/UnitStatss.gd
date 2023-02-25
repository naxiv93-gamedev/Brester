extends Resource
class_name UnitStatss

export (String) var unit_name = ""
enum Movementtypes {Infantry, MechInfantry, Wheels, Chains, Air, Sea}
export(Movementtypes) var movementtype = Movementtypes.Infantry
export (int, 1, 10) var movement_range = 1
export (int, 1, 10) var vision_range = 8
export (bool) var capture = 0
export (bool) var restock = 0
export (bool) var attack_type = 0
export (String) var info = ""
export (int, 1, 99) var max_fuel = 1
export (int, -9999999, 9999999) var cost = 0
export (bool) var carrier = 0
export (int, -9999999, 9999999) var max_units_carry = 0
export (Resource) var primary_weapon = preload("res://gridlessDB_data/UnitsTerrain/objects/Item1.tres")
export (Resource) var secondary_weapon = preload("res://gridlessDB_data/UnitsTerrain/objects/Item2.tres")
