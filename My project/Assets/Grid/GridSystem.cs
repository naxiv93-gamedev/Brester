using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CodeMonkey;
using CodeMonkey.Utils;
public class GridSystem : MonoBehaviour
{
    [SerializeField] private TileMapVisual tileMapVisual;

    [SerializeField] private Vector2Int gridSize;
    [SerializeField] private float cellSize;
    [SerializeField] private Vector3 originPosition;
    private TileMap tileMap;
    private TileMap.TileMapObject.TileMapSprite tileMapSprite;


    private Pathfinding pathfinding;
    private void Start(){
        tileMap = new TileMap(gridSize.x,gridSize.y,cellSize,originPosition);
        tileMap.SetTileMapVisual(tileMapVisual);
        pathfinding = new Pathfinding(gridSize.x,gridSize.y,cellSize,originPosition);

    }

    private void Update(){
        if(Input.GetMouseButtonDown(0)){
            Vector3 mouseWorldPosition = UtilsClass.GetMouseWorldPosition();
            tileMap.SetTileMapSprite(mouseWorldPosition, tileMapSprite);
        }

        if(Input.GetKeyDown(KeyCode.T)){
            tileMapSprite = TileMap.TileMapObject.TileMapSprite.Ground;
            CMDebug.TextPopupMouse(tileMapSprite.ToString());
        }
        if(Input.GetKeyDown(KeyCode.Y)){
            tileMapSprite = TileMap.TileMapObject.TileMapSprite.Sea;
            CMDebug.TextPopupMouse(tileMapSprite.ToString());
        }
        if(Input.GetKeyDown(KeyCode.U)){
            tileMapSprite = TileMap.TileMapObject.TileMapSprite.Forest;
            CMDebug.TextPopupMouse(tileMapSprite.ToString());
        }
        if(Input.GetKeyDown(KeyCode.I)){
            tileMapSprite = TileMap.TileMapObject.TileMapSprite.Road;
            CMDebug.TextPopupMouse(tileMapSprite.ToString());
        }
        if(Input.GetKeyDown(KeyCode.P)){
            tileMap.Save();
            CMDebug.TextPopupMouse("Saved!");
        }
        if(Input.GetKeyDown(KeyCode.L)){
            tileMap.Load();
            CMDebug.TextPopupMouse("Loaded!");
        }
        
    }
}
