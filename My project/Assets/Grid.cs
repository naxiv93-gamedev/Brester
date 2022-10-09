using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CodeMonkey.Utils;
public class Grid<TGridObject>{
    private int width;
    private int height;
    private TGridObject[,] gridArray; 
    private float cellSize;
    private TextMesh[,] debugTextArray;
    private Vector3 originPosition;

    public const int HEAT_MAP_MAX_VALUE = 100;
    public const int HEAT_MAP_MIN_VALUE = 0;

    public bool showDebug = false;


    public event EventHandler <OnGridValueChangedEventArgs> OnGridValueChanged;
    public class OnGridValueChangedEventArgs : EventArgs{
        public int x;
        public int y;
    }


    //Funcionando con Genericos
    public Grid(int width, int height, float cellSize, Vector3 originPosition, Func<Grid<TGridObject>, int, int, TGridObject> createGridObject){
        this.width = width;
        this.height = height;
        this.cellSize = cellSize;
        this.originPosition = originPosition;

        //Creamos los objetos de Grid
        gridArray = new TGridObject[width,height];
        for(int x = 0; x < gridArray.GetLength(0); x++){
            for(int y = 0; y < gridArray.GetLength(1);y++){
                gridArray[x,y] = createGridObject(this, x, y);
            }
        }
        //datos de debug
        if(showDebug){
            debugTextArray = new TextMesh[width,height];

        
            for(int x = 0; x < gridArray.GetLength(0); x++){
                    for(int y = 0; y < gridArray.GetLength(1);y++){
                        debugTextArray[x,y] = UtilsClass.CreateWorldText(gridArray[x,y]?.ToString(),null,GetWorldPosition(x,y) + new Vector3(cellSize,cellSize) * .5f,20,Color.white,TextAnchor.MiddleCenter);
                        Debug.DrawLine(GetWorldPosition(x,y),GetWorldPosition(x,y+1),Color.white,100f);
                        Debug.DrawLine(GetWorldPosition(x,y),GetWorldPosition(x+1,y),Color.white,100f);
                    }
                }
            Debug.DrawLine(GetWorldPosition(0,height),GetWorldPosition(width,height),Color.white,100f);
            Debug.DrawLine(GetWorldPosition(width,0),GetWorldPosition(width,height),Color.white,100f);  
            OnGridValueChanged += (object sender, OnGridValueChangedEventArgs eventArgs) =>{
                debugTextArray[eventArgs.x,eventArgs.y].text = gridArray[eventArgs.x,eventArgs.y]?.ToString();
            };
        } 
    }
    public int GetWidth(){
        return gridArray.GetLength(0);
    }
    public int GetHeight(){
        return gridArray.GetLength(1);
    }
    public float GetCellSize(){
        return cellSize;
    }
    public Vector3 GetWorldPosition(int x, int y){
        return new Vector3(x,y) * cellSize + originPosition;
    }
    //A partir de una posicion global, recogemos la posicion dentro del grid
    public void GetXY(Vector3 worldPosition, out int x, out int y){
        x = Mathf.FloorToInt((worldPosition - originPosition).x / cellSize);
        y = Mathf.FloorToInt((worldPosition - originPosition).y / cellSize);
    }

    //determina si una posicion concreta esta dentro del grid
    public bool isInRange(int x, int y){
        return x >= 0 && x < width
        && 
        y >= 0 && y < height; 
    }

    
    
    public void SetGridObject(int x, int y, TGridObject gridObject){
        if (isInRange(x,y)){
            gridArray[x,y] = gridObject;
            if(showDebug){
                debugTextArray[x,y].text = gridArray[x,y].ToString();
     
            }
            if(OnGridValueChanged != null) OnGridValueChanged(this, new OnGridValueChangedEventArgs{x = x , y = y});  
        } 
    }
    //Activa el evento para actualizar los visuales del grid
    public void TriggerGridObjectChanged(int x, int  y){
        if(OnGridValueChanged != null) OnGridValueChanged(this, new OnGridValueChangedEventArgs{x = x , y = y});  

    }
    public void SetGridObject(Vector3 worldPosition, TGridObject gridObject){
        int x, y;
        GetXY(worldPosition, out x, out y);
        SetGridObject(x,y,gridObject);
    }

    public TGridObject GetGridObject(int x, int y){
        if (isInRange(x,y)){
            return gridArray[x,y];
        }else{
            return default(TGridObject);
        }
    }
    public TGridObject GetGridObject(Vector3 worldPosition){
        int x, y;
        GetXY(worldPosition, out x, out y);
        return GetGridObject(x,y);
    }

}
