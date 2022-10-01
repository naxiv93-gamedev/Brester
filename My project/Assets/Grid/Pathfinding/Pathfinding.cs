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

    
    public List<PathNode> FindPaths(int startX, int startY, int endX, int endY){
        
        PathNode startNode = grid.GetGridObject(startX,startY);
        PathNode endNode = grid.GetGridObject(endX,endY);

        openList = new List<PathNode>();
        closedList = new List<PathNode>();

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
                

                int tentativeGCost = currentNode.gCost + CalculateDistanceCost(currentNode,neighborNode);
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

        return null;

    }

    private List<PathNode> GetNeighborList(PathNode currentNode){
        List<PathNode> neighbors = new List <PathNode>();

        PathNode possibleNeighbor;
        //To the left!
        if(grid.isInRange(currentNode.x - 1, currentNode.y)){
            possibleNeighbor = grid.GetGridObject(currentNode.x - 1, currentNode.y);
            neighbors.Add(possibleNeighbor);
        }
        //To the Right!
        if(grid.isInRange(currentNode.x + 1, currentNode.y)){
            possibleNeighbor = grid.GetGridObject(currentNode.x + 1, currentNode.y);
            neighbors.Add(possibleNeighbor);
        }
        //Above!
        if(grid.isInRange(currentNode.x, currentNode.y - 1)){
            possibleNeighbor = grid.GetGridObject(currentNode.x, currentNode.y - 1);
            neighbors.Add(possibleNeighbor);
        }
        //Below!
        if(grid.isInRange(currentNode.x, currentNode.y + 1)){
            possibleNeighbor = grid.GetGridObject(currentNode.x, currentNode.y + 1);
            neighbors.Add(possibleNeighbor);
        }

        return neighbors;
    }

    private List<PathNode> CalculatePath(PathNode endNode){
        return null;
    }

    private int CalculateDistanceCost(PathNode a, PathNode b){
        int xDistance = Mathf.Abs(a.x - b.x);
        int yDistance = Mathf.Abs(a.y - b.y);
        int remaining = Mathf.Abs(xDistance - yDistance);
        return MOVE_DIAGONAL_COST * MathF.Min(xDistance,yDistance) + MOVE_STRAIGHT_COST * remaining;  
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
        for(x = 0; x < grid.GetWidth();x++){
            for(y = 0; y < grid.GetHeight();y++){
                PathNode node = grid.GetGridObject(x,y);
                node.gCost = int.MaxValue;
                node.CalculateFCost();
                node.cameFromNode = null;
            }   
        }
    }
}
