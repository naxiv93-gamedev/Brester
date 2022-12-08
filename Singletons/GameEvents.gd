extends Node

signal highlightedNewCell(position)
signal cellSelected()
signal moveCursor(event)
signal cellStateSelected(position,script)

#pathfinding signals
signal foundOccupant(cell,occupant)
signal clearGData()
signal drawPath(list)
signal cancelMovement()
signal suitableCell(cell)
signal nextMove(cell,unit)
signal finishedMovement()



signal selectedCancel()
signal selectedWait()
signal selectedAttack()
signal selectedCapture()

signal popupMenu(occupant,destination)

#Structure signals
signal structureActivated(position)

#Unit signals
signal unitSpawned(position, unit)

