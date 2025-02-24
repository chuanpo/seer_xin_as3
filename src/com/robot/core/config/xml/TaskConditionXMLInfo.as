package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class TaskConditionXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = TaskConditionXMLInfo_xmlClass;
      
      setup();
      
      public function TaskConditionXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var _id:uint = 0;
         _dataMap = new HashMap();
         var xmlList:XMLList = XML(new xmlClass()).elements("task");
         for each(item in xmlList)
         {
            _id = uint(item.@id);
            _dataMap.add(_id,item);
         }
      }
      
      public static function getConditionStep(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return xml.@step;
      }
      
      public static function getConditionList(id:uint) : Array
      {
         var i:XML = null;
         var array:Array = [];
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            for each(i in xml.condition)
            {
               array.push(new TaskConditionListInfo(i));
            }
         }
         return array;
      }
   }
}

