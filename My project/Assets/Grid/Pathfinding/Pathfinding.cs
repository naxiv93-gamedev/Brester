using System;
using System.Runtime.CompilerServices;
using System.IO;
    using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Pathfinding 
{
    private const int MOVE_STRAIGHT_COST = 10;
    private const int MOVE_DIAGONAL_COST = 14;

    private Grid<PathNode> grid;
    private int width;
    private int height;

    public Pathfinding(int width, int height,float cellSize,Vector3 originPosition){
        this.grid = new Grid<PathNode>(width, height,cellSize,originPosition,(Grid<PathNode> g, int x, int y) => new PathNode(g,x,y));
    }
    public Grid<PathNode> getGrid(){
        return grid;
    }
    
    public List<PathNode> FindPaths(int startX, int startY, int endX, int endY){
        
        PathNode startNode = grid.GetGridObject(startX,startY);
        PathNode endNode = grid.GetGridObject(endX,endY);

        List<PathNode> openList = new List<PathNode>();
        List<PathNode> closedList = new List<PathNode>();

        wipeNodes();

        startNode.gCost = 0;
        startNode.hCost = CalculateDistanceCost(startNode,endNode);
        startNode.CalculateFCost();

        while(openList.Count > 0){
            PathNode currentNode =  GetLowestFCostNode(openList);
            if(currentNode == endNode){
                return CalculatePath(endNode);
            }
            openList.Remove(currentNode);
            closedList.Add(currentNode);
            foreach(PathNode neighbor in GetNeighborList(currentNode)){
                if(closedList.Contains(neighbor)) continue;
                

                int tentativeGCost = currentNode.gCost + CalculateDistanceCost(currentNode,neighbor);
                if(tentativeGCost < neighbor.gCost){
                    neighbor.cameFromNode = currentNode;
                    neighbor.gCost = tentativeGCost;
                    neighbor.hCost = CalculateDistanceCost(neighbor,endNode);
                    neighbor.CalculateFCost();

                    if(!openList.Contains(neighbor)){
                        openList.Add(neighbor);
                    }
                }
            }
            
        }
        // out of nodes to find

        return null;

    }

    private List<PathNode> GetNeighborList(PathNode currentNode){
        List<PathNode> neighbors = new List <PathNode>();
        Vector2Int currentNodeCoords = currentNode.getCoords(); 
        PathNode possibleNeighbor;
        //To the left!
        if(grid.isInRange(currentNodeCoords.x - 1, currentNodeCoords.y)){
            possibleNeighbor = grid.GetGridObject(currentNodeCoords.x - 1, currentNodeCoords.y);
            neighbors.Add(possibleNeighbor);
        }
        //To the Right!
        if(grid.isInRange(currentNodeCoords.x + 1, currentNodeCoords.y)){
            possibleNeighbor = grid.GetGridObject(currentNodeCoords.x + 1, currentNodeCoords.y);
            neighbors.Add(possibleNeighbor);
        }
        //Above!
        if(grid.isInRange(currentNodeCoords.x, currentNodeCoords.y - 1)){
            possibleNeighbor = grid.GetGridObject(currentNodeCoords.x, currentNodeCoords.y - 1);
            neighbors.Add(possibleNeighbor);
        }
        //Below!
        if(grid.isInRange(currentNodeCoords.x, currentNodeCoords.y + 1)){
            possibleNeighbor = grid.GetGridObject(currentNodeCoords.x, currentNodeCoords.y + 1);
            neighbors.Add(possibleNeighbor);
        }

        return neighbors;
    }

    private List<PathNode> CalculatePath(PathNode endNode){
        List<PathNode> path = new List<PathNode>();
        path.Add(endNode);
        PathNode currentNode = endNode;
        while(currentNode.cameFromNode != null){
            path.Add(currentNode.cameFromNode);

            currentNode = currentNode.cameFromNode;
        }
        path.Reverse();
        return path;
    }

    private int CalculateDistanceCost(PathNode a, PathNode b){
        Vector2Int aCoords = a.getCoords();
        Vector2Int bCoords = b.getCoords(); 
        int xDistance = Mathf.Abs(aCoords.x - bCoords.x);
        int yDistance = Mathf.Abs(aCoords.y - bCoords.y);
        int remaining = Mathf.Abs(xDistance - yDistance);
        int distance = MOVE_DIAGONAL_COST * Mathf.Min(xDistance,yDistance) + MOVE_STRAIGHT_COST * remaining; 
        return distance;  
    }

    private  PathNode GetLowestFCostNode(List<PathNode> pathNodeList){
        PathNode lowestFCostNode = pathNodeList[0];
        for(int i = 1;i < pathNodeList.Count;i++){
            if(pathNodeList[i].fCost < lowestFCostNode.fCost){
                lowestFCostNode = pathNodeList[i];
            }
        }
        return lowestFCostNode;
    }
    private void wipeNodes(){
        for(int x = 0; x < grid.GetWidth();x++){
            for(int y = 0; y < grid.GetHeight();y++){
                PathNode node = grid.GetGridObject(x,y);
                node.gCost = int.MaxValue;
                node.CalculateFCost();
                node.cameFromNode = null;
            }   
        }
    }
}
