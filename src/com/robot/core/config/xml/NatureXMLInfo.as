package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class NatureXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = NatureXMLInfo_xmlClass;
      
      setup();
      
      public function NatureXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("item");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@id),item);
         }
      }
      
      public static function getName(nature:uint) : String
      {
         var item:XML = _dataMap.getValue(nature);
         if(Boolean(item))
         {
            return String(item.@name);
         }
         return "";
      }
      
      public static function getAttack(nature:uint) : Number
      {
         var item:XML = _dataMap.getValue(nature);
         if(Boolean(item))
         {
            return Number(item.@m_attack);
         }
         return -1;
      }
      
      public static function getDefence(nature:uint) : Number
      {
         var item:XML = _dataMap.getValue(nature);
         if(Boolean(item))
         {
            return Number(item.@m_defence);
         }
         return -1;
      }
      
      public static function getSpAttack(nature:uint) : Number
      {
         var item:XML = _dataMap.getValue(nature);
         if(Boolean(item))
         {
            return Number(item.@m_SA);
         }
         return -1;
      }
      
      public static function getSpDefence(nature:uint) : Number
      {
         var item:XML = _dataMap.getValue(nature);
         if(Boolean(item))
         {
            return Number(item.@m_SD);
         }
         return -1;
      }
      
      public static function getSpeed(nature:uint) : Number
      {
         var item:XML = _dataMap.getValue(nature);
         if(Boolean(item))
         {
            return Number(item.@m_speed);
         }
         return -1;
      }

      public static function getDesc(nature:uint) : String
      {
         var item:XML = _dataMap.getValue(nature);
         if(Boolean(item))
         {
            return String(item.@desc);
         }
         return "";
      }
   }
}

