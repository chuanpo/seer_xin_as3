package com.robot.core.info.teamPK
{
   import flash.utils.IDataInput;
   
   public class SeerChartsInfo
   {
      private var list:Array = [];
      
      public function SeerChartsInfo(data:IDataInput)
      {
         super();
         var count:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < count; i++)
         {
            this.list.push(new SeerChartsItemInfo(data));
         }
      }
      
      public function get infoList() : Array
      {
         return this.list;
      }
   }
}

