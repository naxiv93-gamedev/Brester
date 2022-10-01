using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeatMapBoolVisual : MonoBehaviour
{

    private Grid<bool> grid;
    private Mesh mesh;

    private bool updateMesh;

    private void Awake() {
        mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;
    }
    public void setGrid(Grid<bool> grid){
        this.grid = grid;
        UpdateHeatMapVisual();

        grid.OnGridValueChanged += Grid_OnGridValueChanged;
    }

    private void Grid_OnGridValueChanged(object sender, Grid<bool>.OnGridValueChangedEventArgs e) {
        

        updateMesh = true;
        //UpdateHeatMapVisual();
    }

    private void LateUpdate() {
        if(updateMesh){
            updateMesh = false;
            UpdateHeatMapVisual();
        }
    }
    private void UpdateHeatMapVisual(){
        MeshUtils.CreateEmptyMeshArrays(grid.GetWidth() * grid.GetHeight(), out Vector3[] vertices, out Vector2[] uv, out int[] triangles);
        for(int x = 0; x < grid.GetWidth();x++){
            for(int y = 0; y < grid.GetHeight();y++){
                int index = x * grid.GetHeight() + y;
                Vector3 quadSize = new Vector3(1,1) * grid.GetCellSize();
                
                bool gridValue = grid.GetGridObject(x,y);
                

                float gridValueNormalized = gridValue? 1f: 0f;

                if(gridValueNormalized == 1f) Debug.Log(gridValueNormalized);
                
                Vector2 gridValueUV = new Vector2(gridValueNormalized,0f);

                MeshUtils.AddToMeshArrays(vertices, uv, triangles, index, grid.GetWorldPosition(x,y) + quadSize * .5f,0f,quadSize, gridValueUV,gridValueUV);
        
            }
        }

        mesh.vertices = vertices;
        mesh.uv = uv;
        mesh.triangles = triangles;
    }
}
