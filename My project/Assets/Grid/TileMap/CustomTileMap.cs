using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileMap
{

    public event EventHandler OnLoaded;
    private Grid<TileMapObject> grid;
        
    public TileMap(int width, int height,float cellSize, Vector3 originPosition){
        grid = new Grid<TileMapObject>(width,height,cellSize,originPosition, (Grid<TileMapObject> g, int x, int y) => new TileMapObject(g,x,y));
    }

    public void SetTileMapSprite(Vector3 worldPosition, TileMapObject.TileMapSprite tileMapSprite){
        TileMapObject tileMapObject = grid.GetGridObject(worldPosition);
        if(tileMapObject != null){
            tileMapObject.SetTileMapSprite(tileMapSprite);
        }
    }

    public void SetTileMapVisual(TileMapVisual tileMapVisual){
        tileMapVisual.SetGrid(this,grid);
    }

    public void Save(){
        List<TileMapObject.SaveObject> tileMapSavedObjects = new List<TileMapObject.SaveObject>();
        for(int x  = 0;  x < grid.GetWidth(); x++){
            for(int y = 0; y < grid.GetHeight(); y++){
                TileMapObject tileMapObject = grid.GetGridObject(x,y);
                tileMapSavedObjects.Add(tileMapObject.Save());
            }
        }

        SaveObject saveObject = new SaveObject{tileMapSavedObjectsArray = tileMapSavedObjects.ToArray()};
        SaveSystem.SaveObject(saveObject);
    }

    public void Load(){
        SaveObject saveObject = SaveSystem.LoadMostRecentObject<SaveObject>();

        foreach(TileMapObject.SaveObject tileMapSavedObject in saveObject.tileMapSavedObjectsArray){
            TileMapObject tileMapObject = grid.GetGridObject(tileMapSavedObject.x, tileMapSavedObject.y);
            tileMapObject.Load(tileMapSavedObject);

        }
        OnLoaded?.Invoke(this, EventArgs.Empty);
    }


    public class SaveObject{
        public TileMapObject.SaveObject[] tileMapSavedObjectsArray;
    }


    public class TileMapObject{
        private Grid<TileMapObject> grid;
        private TileMapSprite tileMapSprite;
        private int x;
        private int y;
        public enum TileMapSprite{
            Ground,
            Sea,
            Forest,
            Road

        }

        public TileMapObject(Grid<TileMapObject> grid, int x, int y){
            this.grid = grid;
            this.x = x;
            this.y = y;
        }

        public void SetTileMapSprite(TileMapSprite tileMapSprite){
            this.tileMapSprite = tileMapSprite;
            grid.TriggerGridObjectChanged(x,y);
        }

        public TileMapSprite GetTileMapSprite(){
            return tileMapSprite;
        }
        public override string ToString()
        {
            return tileMapSprite.ToString();
        }

        [System.Serializable]
        public class SaveObject{
            public TileMapSprite tileMapSprite;
            public int x;
            public int y;
        }
        public SaveObject Save(){
            return new SaveObject{
                tileMapSprite = tileMapSprite,
                x = x,
                y = y,
            };
        }
        public void Load(SaveObject saveObject){
            tileMapSprite = saveObject.tileMapSprite;
        }
    }

}
