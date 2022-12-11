extends Resource

class_name Weapon

export (String) var name = ""
export (int, 1, 10) var minRange = 1
export (int, 1, 10) var maxRange = 1

export (int, 1,99) var maxAmmo
export (int, 0, 99) var damageToInfantry
export (int, 0, 99) var damageToTanks
export (int, 0, 99) var damageToBcopter
export (int, 0, 99) var damageToAntiair

var ammo


var damageDict = {}

func _init():
	ammo = maxAmmo
	call_deferred("setUpChart")
	
func setUpChart():
	damageDict = {
		#stats.unitName : damageToUnit
		"Infantry":damageToInfantry,
		"Tank":damageToTanks,
		"Bcopter":damageToBcopter,
		"Antiair":damageToAntiair,
	}

func isIndirect():
	return maxRange > 1

func canHit(unitResource):
	return damageDict[unitResource] == 0
