
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TileMapVisual : MonoBehaviour
{
    [System.Serializable]
    public struct  TileMapSpriteCoords{
        public TileMap.TileMapObject.TileMapSprite tileMapSprite;
        public int xPosition;
        public int yPosition;
    }

    private struct UVCoords{
        public Vector2 uv00;
        public Vector2 uv11;
    }
    
    
    [SerializeField]
    private Vector2Int tilePixelSize;
    [SerializeField] private TileMapSpriteCoords[] tileMapSpriteUVArray;
    private Grid<TileMap.TileMapObject> grid;
    private Mesh mesh;

    private bool updateMesh;

    private Dictionary<TileMap.TileMapObject.TileMapSprite,UVCoords> uvCoordsDictionary;

    
    
    private void Awake() {
        mesh = new Mesh();
        GetComponent<MeshFilter>().mesh = mesh;
        
        Texture texture = GetComponent<MeshRenderer>().material.mainTexture;
        float textureWidth = texture.width;
        float textureHeight = texture.height;
        uvCoordsDictionary = new Dictionary<TileMap.TileMapObject.TileMapSprite, UVCoords>();
        
        foreach(TileMapSpriteCoords tileMapSpriteCoords in tileMapSpriteUVArray){
            int xPos00 = tileMapSpriteCoords.xPosition * tilePixelSize.x;
            int yPos00 = tileMapSpriteCoords.yPosition * tilePixelSize.y;
            int xPos11 = xPos00 + (tilePixelSize.x-1);
            int yPos11 = yPos00 + tilePixelSize.y;
            UVCoords uvs = new UVCoords{
                uv00 = new Vector2((xPos00/ textureWidth)+0.01f,yPos00/textureHeight),
                uv11 = new Vector2(xPos11/ textureWidth,yPos11/textureHeight),
            };
            uvCoordsDictionary[tileMapSpriteCoords.tileMapSprite] = uvs;


        }

    }

    public void SetGrid(TileMap tileMap, Grid<TileMap.TileMapObject> grid){
        this.grid = grid;
        UpdateTileMapVisual();

        grid.OnGridValueChanged += Grid_OnGridValueChanged;
        tileMap.OnLoaded += TileMap_OnLoaded;
    }
    private void TileMap_OnLoaded(object sender,System.EventArgs e) {
        updateMesh = true;
    }
    private void Grid_OnGridValueChanged(object sender, Grid<TileMap.TileMapObject>.OnGridValueChangedEventArgs e) {
        updateMesh = true;
    }

    private void LateUpdate() {
        if(updateMesh){
            updateMesh = false;
            UpdateTileMapVisual();
        }
    }
    private void UpdateTileMapVisual(){
        MeshUtils.CreateEmptyMeshArrays(grid.GetWidth() * grid.GetHeight(), out Vector3[] vertices, out Vector2[] uv, out int[] triangles);
        for(int x = 0; x < grid.GetWidth();x++){
            for(int y = 0; y < grid.GetHeight();y++){
                int index = x * grid.GetHeight() + y;
                Vector3 quadSize = new Vector3(1,1) * grid.GetCellSize();
                
                TileMap.TileMapObject gridObject = grid.GetGridObject(x,y);
                TileMap.TileMapObject.TileMapSprite tileMapSprite = gridObject.GetTileMapSprite();

                Vector2 gridUV00, gridUV11;
                UVCoords uvCoords;
                switch(tileMapSprite){
                    case TileMap.TileMapObject.TileMapSprite.Ground:
                        uvCoords = uvCoordsDictionary[tileMapSprite];
                        gridUV00 = uvCoords.uv00;
                        gridUV11 = uvCoords.uv11;
                        break;
                    
                    case TileMap.TileMapObject.TileMapSprite.Sea:
                        uvCoords = uvCoordsDictionary[tileMapSprite];
                        gridUV00 = uvCoords.uv00;
                        gridUV11 = uvCoords.uv11;
                        break;
                    case TileMap.TileMapObject.TileMapSprite.Forest:
                        uvCoords = uvCoordsDictionary[tileMapSprite];
                        gridUV00 = uvCoords.uv00;
                        gridUV11 = uvCoords.uv11;
                        break;
                    case TileMap.TileMapObject.TileMapSprite.Road:
                        uvCoords = uvCoordsDictionary[tileMapSprite];
                        gridUV00 = uvCoords.uv00;
                        gridUV11 = uvCoords.uv11;
                        break;
                    default:
                        gridUV00 = Vector2.zero;
                        gridUV11 = Vector2.zero;
                        break;
                }

                MeshUtils.AddToMeshArrays(vertices, uv, triangles, index, grid.GetWorldPosition(x,y) + quadSize * .5f,0f,quadSize, gridUV00,gridUV11);
        
            }
        }

        mesh.vertices = vertices;
        mesh.uv = uv;
        mesh.triangles = triangles;
    }

    
}
