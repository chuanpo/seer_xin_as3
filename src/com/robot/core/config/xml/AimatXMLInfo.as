package com.robot.core.config.xml
{
   import com.robot.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.ArrayUtil;
   
   public class AimatXMLInfo
   {
      private static var _dataList:Array;
      
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = AimatXMLInfo_xmlClass;
      
      setup();
      
      public function AimatXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var _id:uint = 0;
         var _tranID:uint = 0;
         var arr:Array = null;
         var typeID:uint = 0;
         var arr2:Array = null;
         var i:String = null;
         _dataList = [];
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("item");
         for each(item in xl)
         {
            _id = uint(item.@id);
            _tranID = uint(item.@tranID);
            arr = String(item.@cloth).split(",");
            typeID = uint(item.@type);
            arr2 = [];
            for each(i in arr)
            {
               arr2.push(uint(i));
            }
            _dataList.push({
               "id":_id,
               "cloth":arr2,
               "tranID":_tranID,
               "type":typeID
            });
            _dataMap.add(_id,item);
         }
      }
      
      public static function getType(data:Array) : uint
      {
         var item:Object = null;
         var arr:Array = null;
         for each(item in _dataList)
         {
            arr = item.cloth;
            if(ArrayUtil.embody(data,arr))
            {
               if(Boolean(MainManager.actorModel))
               {
                  if(MainManager.actorModel.isTransform && item.tranID != 0)
                  {
                     return item.tranID;
                  }
                  return item.id;
               }
               return item.id;
            }
         }
         return _dataList[0].id;
      }
      
      public static function getTypeId(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return uint(xml.@type);
         }
         return 0;
      }
      
      public static function getSoundStart(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Number(xml.@soundStart);
         }
         return 0;
      }
      
      public static function getIsStage(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return uint(xml.@isState);
         }
         return 0;
      }
      
      public static function getSoundEnd(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Number(xml.@soundEnd);
         }
         return 0;
      }
      
      public static function getSpeed(id:uint) : Number
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Number(xml.@speed);
         }
         return 0;
      }
      
      public static function getCloths(id:uint) : Array
      {
         var item:Object = null;
         for each(item in _dataList)
         {
            if(item.id == id)
            {
               return item.cloth;
            }
         }
         return [];
      }
   }
}

