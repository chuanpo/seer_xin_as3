package com.robot.app.tasksRecord
{
   import com.robot.core.utils.TextFormatUtil;
   
   public class TasksRecordConfig
   {
      private static var _allIdA:Array;
      
      private static var xmlClass:Class = TasksRecordConfig_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function TasksRecordConfig()
      {
         super();
      }
      
      public static function getStarIDByName(name:String) : String
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         xmlList = xml.descendants("star");
         xml = xmlList.(@name == name)[0];
         return xml.@id;
      }
      
      public static function getXML() : XML
      {
         return xml.copy();
      }
      
      public static function getTaskLength() : uint
      {
         var xmlList:XMLList = xml.elements("task");
         return xmlList.length();
      }
      
      public static function getAllTasksId() : Array
      {
         var list:XML = null;
         var xmlList:XMLList = xml.elements("task");
         _allIdA = new Array();
         for each(list in xmlList)
         {
            _allIdA.push(uint(list.@id));
         }
         return _allIdA;
      }
      
      public static function get allIdA() : Array
      {
         if(!_allIdA)
         {
            _allIdA = new Array();
         }
         return _allIdA;
      }
      
      public static function getName(id:uint) : String
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         return xml.@name;
      }
      
      public static function getIsVip(id:uint) : Boolean
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         if(Boolean(xml.hasOwnProperty("@isVip")))
         {
            return Boolean(xml.@isVip);
         }
         return false;
      }
      
      public static function getParentId(id:uint) : uint
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         var parentId:uint = 0;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         parentId = uint(xml.@parentId);
         return parentId;
      }
      
      public static function getOnlineData(id:uint) : Number
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         var data:Number = NaN;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         data = Number(xml.@onlineData);
         return data;
      }
      
      public static function getTaskNpcForId(id:uint) : String
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         var npcName:String = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         npcName = xml.@npc;
         return npcName;
      }
      
      public static function getTaskNpcTips(id:uint) : String
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         var npcName:String = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         npcName = xml.@tip;
         return npcName;
      }
      
      public static function getTaskOffLineForId(id:uint) : Boolean
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         return Boolean(uint(xml.@offline));
      }
      
      public static function getTaskNewOnlineForId(id:uint) : Boolean
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         return Boolean(uint(xml.@newOnline));
      }
      
      public static function getAltTaskMapId(id:uint) : uint
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         return uint(xml.@mapId);
      }
      
      public static function getTaskType(id:uint) : uint
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         return uint(xml.@type);
      }
      
      public static function getTaskStartDes(id:uint) : String
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         var des:String = null;
         var a:Array = null;
         var i1:int = 0;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         des = xml.startDes;
         if(des.indexOf("#") == -1)
         {
            return des;
         }
         a = des.split("#");
         a[a.length - 1] = TextFormatUtil.getRedTxt(a[a.length - 1]);
         des = "";
         for(i1 = 0; i1 < a.length; i1++)
         {
            des += a[i1];
         }
         return des;
      }
      
      public static function getTaskStopDes(id:uint) : String
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         var des:String = null;
         var a:Array = null;
         var i1:int = 0;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         des = xml.stopDes;
         if(des.indexOf("#") == -1)
         {
            return des;
         }
         a = des.split("#");
         a[a.length - 1] = TextFormatUtil.getRedTxt(a[a.length - 1]);
         des = "";
         for(i1 = 0; i1 < a.length; i1++)
         {
            des += a[i1];
         }
         return des;
      }
      
      public static function getTaskReward(id:uint) : Array
      {
         var xmlList:XMLList = null;
         var xml:XML = null;
         var des:String = null;
         var arr:Array = null;
         var i:uint = 0;
         var ar:Array = null;
         var i2:int = 0;
         var str:String = null;
         var a:Array = null;
         var i1:int = 0;
         xmlList = xml.descendants("task");
         xml = xmlList.(@id == id.toString())[0];
         des = xml.outPut;
         if(des.indexOf("|") == -1)
         {
            if(des.indexOf("#") == -1)
            {
               return [des];
            }
            ar = des.split("#");
            ar[ar.length - 1] = TextFormatUtil.getRedTxt(ar[ar.length - 1]);
            des = "";
            for(i2 = 0; i2 < ar.length; i2++)
            {
               des += ar[i2];
            }
            return [des];
         }
         arr = des.split("|");
         for(i = 0; i < arr.length; i++)
         {
            str = arr[i];
            if(str.indexOf("#") != -1)
            {
               a = str.split("#");
               a[a.length - 1] = TextFormatUtil.getRedTxt(a[a.length - 1]);
               str = "";
               for(i1 = 0; i1 < a.length; i1++)
               {
                  str += a[i1];
               }
               arr[i] = str;
            }
         }
         return arr;
      }
   }
}

