package com.robot.core.info.item
{
   public class ClothData
   {
      private var xml:XML;
      
      public function ClothData(xml:XML)
      {
         super();
         this.xml = xml;
      }
      
      public function get price() : uint
      {
         return this.xml.@Price;
      }
      
      public function get type() : String
      {
         return this.xml.@type;
      }
      
      public function get id() : int
      {
         return int(this.xml.@ID);
      }
      
      public function get name() : String
      {
         return this.xml.@Name;
      }
      
      public function getUrl(level:uint = 0) : String
      {
         if(level == 0 || level == 1)
         {
            return XML(this.xml.parent()).@url + this.id.toString() + ".swf";
         }
         return XML(this.xml.parent()).@url + this.id.toString() + "_" + level + ".swf";
      }
      
      public function getIconUrl(level:uint = 0) : String
      {
         return this.getUrl(level).replace(/swf\//,"icon/");
      }
      
      public function getPrevUrl(level:uint = 0) : String
      {
         return this.getUrl(level).replace(/swf\//,"prev/");
      }
      
      public function get actionDir() : int
      {
         if(String(this.xml.@actionDir) == "")
         {
            return -1;
         }
         return int(this.xml.@actionDir);
      }
      
      public function get repairPrice() : uint
      {
         return uint(this.xml.@RepairPrice);
      }
   }
}

