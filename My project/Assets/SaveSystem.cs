using System.IO;
using System.Net.Mime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class SaveSystem
{
    private const string SAVE_EXTENSION = "txt";

    private static  readonly string SAVE_FOLDER = Application.dataPath + "/Saves/";
    private static bool isInit = false;

    public static void Init(){
        if(!isInit){
            isInit = true;
            if(!Directory.Exists(SAVE_FOLDER)){
                Directory.CreateDirectory(SAVE_FOLDER);
            }
        }
    }

    public static void Save(string fileName, string saveString, bool overwrite){
        Init();
        string saveFileName = fileName;
        if(!overwrite){
            int saveNumber = 1;
            
            while(File.Exists(getFullFileName(saveFileName))){
                saveNumber++;
                saveFileName = fileName + "_" + saveNumber;
            }
        }
        File.WriteAllText(getFullFileName(saveFileName),saveString);
    }
    public static string Load(string fileName){
        Init();
        string fullFileName = getFullFileName(fileName); 
        if(File.Exists(fullFileName)){
            string saveString = File.ReadAllText(fullFileName);
            return saveString;
        }else{
            return null;
        }
    }


    public static string LoadMostRecentFile(){
        Init();
        DirectoryInfo directoryInfo = new DirectoryInfo(SAVE_FOLDER);

        FileInfo[] saveFiles = directoryInfo.GetFiles("*." + SAVE_EXTENSION);

        FileInfo mostRecentFile = saveFiles[0];
        foreach(FileInfo fileInfo in saveFiles){
            if(fileInfo.LastWriteTime > mostRecentFile.LastWriteTime){
                mostRecentFile = fileInfo;
            }
        }

        if (mostRecentFile != null){
            string saveString = File.ReadAllText(mostRecentFile.FullName);
            return saveString;
        }else{
            return null;
        }
    }

    public static void SaveObject(object saveObject){
        SaveObject("save", saveObject, false);
    }

    public static void SaveObject(string fileName,object saveObject, bool overwrite){
        Init();
        string json = JsonUtility.ToJson(saveObject);
        Save(fileName, json, overwrite);
    }

    public static TSaveObject LoadMostRecentObject<TSaveObject>(){
        Init();
        string saveString = LoadMostRecentFile();
        if(saveString != null){
            TSaveObject saveObject = JsonUtility.FromJson<TSaveObject>(saveString);
            return saveObject;
        }else{
            return default(TSaveObject);
        }
    }

    public static TSaveObject LoadObject<TSaveObject>(string fileName){
        Init();
        string saveString = Load(fileName);

        if(saveString != null){
            TSaveObject saveObject = JsonUtility.FromJson<TSaveObject>(saveString);
            return saveObject;
        }else{
            return default(TSaveObject);
        }
    }
    private static string getFullFileName(string fileName){
        return SAVE_FOLDER + fileName + "." + SAVE_EXTENSION;
    }
}
