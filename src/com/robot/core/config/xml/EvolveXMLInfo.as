package com.robot.core.config.xml
{
   public class EvolveXMLInfo
   {
      private static var xml:XML;
      
      private static var xmlcls:Class = EvolveXMLInfo_xmlcls;
      
      public function EvolveXMLInfo()
      {
         super();
      }
      
      private static function getXMLData() : XML
      {
         if(xml == null)
         {
            xml = new XML(new xmlcls());
         }
         return xml;
      }
      
      public static function getEvolveID() : Array
      {
         var i:XML = null;
         var arr:Array = new Array();
         var xmllist:XMLList = EvolveXMLInfo.getXMLData().elements("Evolve");
         for each(i in xmllist)
         {
            arr.push(Number(i.@ID));
         }
         if(arr.length <= 0)
         {
            trace("EvolveXMLInfo Class getEvolveID method \t 没有进化类型！");
            return null;
         }
         return arr;
      }
      
      public static function getMonToIDs(evolveID:Number) : Array
      {
         var i:XML = null;
         var monToXMLList:XMLList = null;
         var j:XML = null;
         var obj:Object = null;
         var arr:Array = new Array();
         var xmllist:XMLList = EvolveXMLInfo.getXMLData().elements("Evolve");
         for each(i in xmllist)
         {
            if(Number(i.@ID) == evolveID)
            {
               monToXMLList = i.elements("Branch");
               for each(j in monToXMLList)
               {
                  obj = new Object();
                  obj.MonTo = Number(j.@MonTo);
                  obj.EvolvItem = Number(j.@EvolvItem);
                  obj.EvolvItemCount = Number(j.@EvolvItemCount);
                  arr.push(obj);
               }
            }
         }
         if(arr.length <= 0)
         {
            trace("EvolveXMLInfo Class getMonToIDs method \t 没有匹配进化类型！");
            return null;
         }
         return arr;
      }
      
      public static function getEvolveItem(evolveID:Number, monToID:Number) : Number
      {
         return 0;
      }
      
      public static function getEvolveCount(evolveID:Number, monToID:Number) : Number
      {
         return 0;
      }
   }
}

