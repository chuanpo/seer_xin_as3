package com.robot.core.config
{
   import org.taomee.ds.HashMap;
   
   public class ServerConfig
   {
      private static var xml:XML;
      
      private static var hashMap:HashMap = new HashMap();
      
      public function ServerConfig()
      {
         super();
      }
      
      public static function setup(_xml:XML) : void
      {
         var i:XML = null;
         xml = _xml;
         var count:uint = 1;
         for each(i in XML(xml.ServerList).descendants("list"))
         {
            hashMap.add(count,i.@name);
            count++;
         }
      }
      
      public static function getNameByID(id:uint) : String
      {
         if(!hashMap.containsKey(id))
         {
            return id + "服务器";
         }
         return hashMap.getValue(id).toString();
      }
   }
}

