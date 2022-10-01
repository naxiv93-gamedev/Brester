using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CodeMonkey.Utils;

public class TestingHeatMap : MonoBehaviour
{
    [SerializeField] private HeatMapVisual heatMapVisual;
    [SerializeField] private HeatMapBoolVisual heatMapBoolVisual;
    [SerializeField] private HeatMapGenericVisual heatMapGenericVisual;
    private Grid<HeatMapGridObject> grid;
    
    // Start is called before the first frame update
    void Start()
    {
        grid = new Grid<HeatMapGridObject>(100 ,100,10f,new Vector3(0,0,0), (Grid<HeatMapGridObject> g, int x, int y) => new HeatMapGridObject(g, x, y));
       // heatMapVisual.setGrid(grid);
       //heatMapBoolVisual.setGrid(grid);
       heatMapGenericVisual.setGrid(grid);
    }
    private void Update(){
        if(Input.GetMouseButtonDown(0)){
            Vector3 position = UtilsClass.GetMouseWorldPosition();
            //grid.addValue(position,100,2,15);
            //grid.SetValue(position,true);
            HeatMapGridObject heatMapGridObject = grid.GetGridObject(position);
            if(heatMapGridObject != null){
                heatMapGridObject.AddValue(5);
            }
            

        }
        if(Input.GetMouseButtonDown(1)){
            Debug.Log(grid.GetGridObject(UtilsClass.GetMouseWorldPosition()));
        }
    }
}
public class HeatMapGridObject{
    private const int MIN = 0;
    private const int MAX = 100;

    private int x;
    private int y;

    private Grid<HeatMapGridObject> grid;
    private int value;
    

    public HeatMapGridObject(Grid<HeatMapGridObject> grid, int x, int y){
        this.grid = grid;
        this.x = x;
        this.y = y;
    }

    public void AddValue(int addValue){
        value += addValue;
        value = Mathf.Clamp(value,MIN,MAX);
        grid.TriggerGridObjectChanged(x,y);
    }
    public float GetValueNormalized(){
        return(float) value / MAX;
    }
    public override string ToString(){
        return value.ToString();
    }
}
