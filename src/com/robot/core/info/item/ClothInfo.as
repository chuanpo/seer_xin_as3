package com.robot.core.info.item
{
   import flash.utils.Dictionary;
   
   public class ClothInfo
   {
      private static var dict:Dictionary;
      
      public static const DEFAULT_HEAD:uint = 100001;
      
      public static const DEFAULT_WAIST:uint = 100002;
      
      public static const DEFAULT_FOOT:uint = 100003;
      
      public function ClothInfo()
      {
         super();
      }
      
      public static function parseInfo(xml:XML) : void
      {
         var i:XML = null;
         dict = new Dictionary(true);
         var xmllist:XMLList = xml.descendants("Item");
         for each(i in xmllist)
         {
            dict["item_" + i.@ID.toString()] = i;
         }
      }
      
      public static function getItemInfo(id:int) : ClothData
      {
         if(!dict["item_" + id.toString()])
         {
            throw new Error("没有找到对应的物品ID：" + id);
         }
         return new ClothData(dict["item_" + id.toString()]);
      }
   }
}

