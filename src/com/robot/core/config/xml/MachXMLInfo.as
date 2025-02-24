package com.robot.core.config.xml
{
   import com.robot.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   
   public class MachXMLInfo
   {
      private static var xmlClass:Class = MachXMLInfo_xmlClass;
      
      private static var _actionMap:HashMap = new HashMap();
      
      private static var _expMap:HashMap = new HashMap();
      
      private static var _linesMap:HashMap = new HashMap();
      
      private static var _superExpMap:HashMap = new HashMap();
      
      private static var _superLinesMap:HashMap = new HashMap();
      
      setup();
      
      public function MachXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var xl:XMLList = null;
         var item:XML = null;
         xl = XML(new xmlClass()).elements("action")[0].elements("item");
         for each(item in xl)
         {
            _actionMap.add(uint(item.@id),item);
         }
         xl = XML(new xmlClass()).elements("exp")[0].elements("item");
         for each(item in xl)
         {
            _expMap.add(uint(item.@id),item);
         }
         xl = XML(new xmlClass()).elements("lines")[0].elements("item");
         for each(item in xl)
         {
            _linesMap.add(uint(item.@id),item);
         }
         xl = XML(new xmlClass()).elements("superExp")[0].elements("item");
         for each(item in xl)
         {
            _superExpMap.add(uint(item.@id),item);
         }
         xl = XML(new xmlClass()).elements("superLines")[0].elements("item");
         for each(item in xl)
         {
            _superLinesMap.add(uint(item.@id),item);
         }
      }
      
      public static function getActionName(id:uint) : String
      {
         var item:XML = _actionMap.getValue(id);
         if(Boolean(item))
         {
            return String(item.@name);
         }
         return "";
      }
      
      public static function getExpName(id:uint) : String
      {
         var item:XML = null;
         if(MainManager.actorInfo.superNono)
         {
            item = _superExpMap.getValue(id);
         }
         else
         {
            item = _expMap.getValue(id);
         }
         if(Boolean(item))
         {
            return String(item.@name);
         }
         return "";
      }
      
      public static function getLinesName(id:uint) : String
      {
         var item:XML = null;
         if(MainManager.actorInfo.superNono)
         {
            item = _superLinesMap.getValue(id);
         }
         else
         {
            item = _linesMap.getValue(id);
         }
         if(Boolean(item))
         {
            return String(item.@name);
         }
         return "";
      }
      
      public static function getActionIsAutoEnd(id:uint) : Boolean
      {
         var item:XML = _actionMap.getValue(id);
         if(Boolean(item))
         {
            return Boolean(int(item.@autoEnd));
         }
         return true;
      }
      
      public static function getActionSouLoops(id:uint) : int
      {
         var item:XML = _actionMap.getValue(id);
         if(Boolean(item))
         {
            if(!item.hasOwnProperty("@souLoops"))
            {
               return 0;
            }
            return int(item.@souLoops);
         }
         return 0;
      }
      
      public static function getExpID() : Array
      {
         var xmlArr:Array = null;
         var arr:Array = null;
         if(MainManager.actorInfo.superNono)
         {
            xmlArr = _superExpMap.getValues();
         }
         else
         {
            xmlArr = _expMap.getValues();
         }
         arr = [];
         xmlArr.forEach(function(item:XML, index:int, array:Array):void
         {
            var len:int = int(item.@odds);
            var id:uint = uint(item.@id);
            for(var i:int = 0; i < len; i++)
            {
               arr.push(id);
            }
         });
         return arr;
      }
      
      public static function getLinesIDForExp(id:uint, en:uint, m:uint) : Array
      {
         var item:XML = null;
         var str:String = null;
         var arr:Array = null;
         var outArr:Array = null;
         var eid:uint = 0;
         var enstr:String = null;
         var mstr:String = null;
         if(MainManager.actorInfo.superNono)
         {
            item = _superExpMap.getValue(id);
         }
         else
         {
            item = _expMap.getValue(id);
         }
         if(Boolean(item))
         {
            str = String(item.@lines);
            arr = str.split(",");
            outArr = [];
            for each(eid in arr)
            {
               if(MainManager.actorInfo.superNono)
               {
                  item = _superLinesMap.getValue(eid);
               }
               else
               {
                  item = _linesMap.getValue(id);
               }
               if(Boolean(item))
               {
                  enstr = String(item.@energy);
                  if(enstr.indexOf(en.toString()) != -1)
                  {
                     mstr = String(item.@mate);
                     if(mstr.indexOf(m.toString()) != -1)
                     {
                        outArr.push(eid);
                     }
                  }
               }
            }
            return outArr;
         }
         return [];
      }
   }
}

