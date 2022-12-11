extends Node

signal requestPlayerNames(referee)
signal askPlayerName(beginTurn)
signal askPlayerIncome(beginTurn)
signal beginTurn()
signal editBeginTurnLabels(player,income)
signal editPlayerUI(player)
signal clearButtons()
signal requestPlayerInfoEdit(player,income)
signal highlightedNewCell(position)
signal cellSelected()
signal moveCursor(event)
signal moveCursorCombat(combat,event)
signal cellStateSelected(position,script)
signal tileSelectedCombat(unit, tile)
signal validCombatTile(tile)


#sfx signals
signal playAccept()

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
signal selectedCancelIdle()
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

signal popUpIdleMenu(tile)
signal popUpStructureMenu(tile)
#Structure signals
signal structureFound(pos,structure,player)
signal sendStructure(pos,structure,player)
signal structureActivated(tile)
signal captureStructure(tile)

#Unit signals
signal unitSpawned(position,tileName)


#Turn management signals
signal sendUnits(referee,player)

signal isOccupantFromActivePlayer(idle,occupant)
signal isStructureFromActivePlayer(tile)

signal beginPlayerTurn(player)

signal startGame()

signal foundWinner(player)

signal backToMenu()
signal requestWinner(victoryScene)
	
signal selectedInfantry()
signal selectedTank()
signal selectedAntiair()
signal selectedBcopter()

signal askPlayerMoney(menu)
signal unitMenuDespawns()
signal unitDied(unit)
