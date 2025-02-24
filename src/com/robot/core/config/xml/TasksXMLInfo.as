package com.robot.core.config.xml
{
   import com.robot.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   
   public class TasksXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static const PRO:String = "pro";
      
      private static var xmlClass:Class = TasksXMLInfo_xmlClass;
      
      setup();
      
      public function TasksXMLInfo()
      {
         super();
      }
      
      public static function get dataMap() : HashMap
      {
         return _dataMap;
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var _id:uint = 0;
         _dataMap = new HashMap();
         var xmlList:XMLList = XML(new xmlClass()).elements("task");
         for each(item in xmlList)
         {
            _id = uint(item.@ID);
            _dataMap.add(_id,item);
         }
      }
      
      public static function getName(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@name.toString();
         }
         return "";
      }
      
      public static function getEspecial(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(uint(xml.@especial));
         }
         return false;
      }
      
      public static function getDoc(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@doc.toString();
         }
         return "";
      }
      
      public static function getAlert(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@alert.toString();
         }
         return "";
      }
      
      public static function isMat(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(int(xml.@isMat));
         }
         return false;
      }
      
      public static function getType(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return uint(xml.@type);
         }
         return 0;
      }
      
      public static function isEnd(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(int(xml.@isEnd));
         }
         return false;
      }
      
      public static function isDir(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(int(xml.@isDir));
         }
         return false;
      }
      
      public static function getParent(id:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            str = xml.@parent.toString();
            if(str == "")
            {
               return [];
            }
            return str.split("|");
         }
         return [];
      }
      
      public static function getTaskPorCount(id:uint) : int
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO).length();
         }
         return 0;
      }
      
      public static function getProName(id:uint, pro:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO)[pro].@name.toString();
         }
         return "";
      }
      
      public static function getProDoc(id:uint, pro:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO)[pro].@doc.toString();
         }
         return "";
      }
      
      public static function getProAlert(id:uint, pro:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO)[pro].@alert.toString();
         }
         return "";
      }
      
      public static function getProParent(id:uint, pro:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            str = xml.elements(PRO)[pro].@parent.toString();
            if(str == "")
            {
               return [];
            }
            return str.split("|");
         }
         return [];
      }
      
      public static function isProMat(id:uint, pro:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(int(xml.elements(PRO)[pro].@isMat));
         }
         return false;
      }
      
      public static function getTaskDes(id:uint) : String
      {
         var str:String = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            str = String(xml.taskDes);
            return str.replace(/#nick/g,MainManager.actorInfo.nick);
         }
         return "";
      }
      
      public static function getProDes(id:uint) : String
      {
         var str:String = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            str = String(xml.proDes);
            return str.replace(/#nick/g,MainManager.actorInfo.nick);
         }
         return "";
      }
      
      public static function getIsCondition(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(int(xml.@condition));
         }
         return false;
      }
   }
}

