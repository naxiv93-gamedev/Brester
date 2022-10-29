extends Node

signal highlightedNewCell(position)
signal cellSelected(position)


#pathfinding signals
signal clearGData()
signal drawPath(list)

#Structure signals
signal structureActivated(position)

#Unit signals
signal unitSpawned(position, unit)
