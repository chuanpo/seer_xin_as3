package com.robot.core.config.xml
{
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.skeleton.ClothPreview;
   import org.taomee.ds.HashMap;
   
   public class ShotDisXMLInfo
   {
      private static var xmllist:XMLList;
      
      private static var _map:HashMap;
      
      private static var DEFAULT:uint;
      
      private static var xmlClass:Class = ShotDisXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      setup();
      
      public function ShotDisXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         DEFAULT = uint(xml.@defaultDis);
         _map = new HashMap();
         var xl:XMLList = xml.elements("item");
         for each(item in xl)
         {
            _map.add(item.@id.toString(),item);
         }
      }
      
      public static function getDistance(id:uint) : uint
      {
         var xml:XML = _map.getValue(id.toString());
         if(Boolean(xml))
         {
            return uint(xml.@dis);
         }
         return DEFAULT;
      }
      
      public static function getClothDistance(array:Array) : uint
      {
         var i:uint = 0;
         for each(i in array)
         {
            if(ClothInfo.getItemInfo(i).type == ClothPreview.FLAG_HEAD)
            {
               break;
            }
         }
         return ItemXMLInfo.getShotDis(i);
      }
   }
}

