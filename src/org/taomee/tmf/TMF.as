package org.taomee.tmf
{
   import flash.utils.Dictionary;
   
   public class TMF
   {
      private static var dataDic:Dictionary = new Dictionary();
      
      public function TMF()
      {
         super();
      }
      
      public static function getClass(id:uint) : Class
      {
         if(dataDic[id] == null)
         {
            return TmfByteArray;
         }
         return dataDic[id];
      }
      
      public static function removeClass(id:uint) : void
      {
         delete dataDic[id];
      }
      
      public static function registerClass(id:uint, cs:Class) : void
      {
         dataDic[id] = cs;
      }
   }
}

