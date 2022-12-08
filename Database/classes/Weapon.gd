extends Resource

class_name Weapon

export (String) var name = ""
export (int, 1, 10) var minRange = 1
export (int, 1, 10) var maxRange = 1

export (int, 1,99) var maxAmmo
export (int, 0, 99) var damageToInfantry

var ammo

var damageDict = {
	#preload(unitResource) : damageToUnit
	load("res://Database/objects/UnitStats/Infantry.tres"):damageToInfantry
}

func _init():
	ammo = maxAmmo

func isIndirect():
	return maxRange > 1

func canHit(unitResource):
	return damageDict[unitResource] == 0
