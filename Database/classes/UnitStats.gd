extends Resource
class_name UnitStats


export (String) var unit_name = ""

export (Resource) var mainWeapon
export (Resource) var secondaryWeapon

enum MovementTypes {Infantry, MechInfantry, Wheels, Chains, Air, Sea}
export(MovementTypes) var movementType = MovementTypes.Infantry

export (int, 1, 10) var movement_range = 1
export (int, 1, 10) var vision_range = 1

export (bool) var canCapture = false
export (bool) var canRestock = false
export (bool) var canCarry = false

export (int, 0, 4) var max_units_carry = 0


export (int, 1, 99) var max_fuel = 99
export (int, 0, 9999999) var cost = 0

export (String) var info = ""




