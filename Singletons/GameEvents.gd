extends Node

signal highlightedNewCell(position)
signal cellSelected()
signal moveCursor(event)
signal moveCursorCombat(combat,event)
signal cellStateSelected(position,script)
signal tileSelectedCombat(unit, tile)
signal validCombatTile(tile)

#pathfinding signals
signal foundOccupant(cell,occupant)
signal clearGData()
signal drawPath(list)
signal cancelMovement()
signal suitableCell(cell)
signal nextMove(cell,unit)
signal finishedMovement()

#Idle menu signals
signal selectedEndTurnIdle()

#Moving menu signals
signal selectedCancelMoving()
signal selectedWaitMoving()
signal selectedAttackMoving()
signal selectedCaptureMoving()

#Combat menu signals
signal selectedSwitchCombat()
signal selectedCancelCombat()
signal selectedAttackCombat()

signal popupMenu(occupant,destination)

#Structure signals
signal structureActivated(position)

#Unit signals
signal unitSpawned(position,unit,player)

#Turn management signals
signal sendUnits(referee,player)

signal isOccupantFromActivePlayer(idle,occupant)
