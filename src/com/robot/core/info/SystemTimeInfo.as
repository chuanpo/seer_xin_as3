package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class SystemTimeInfo
   {
      private var _date:Date;
      
      public function SystemTimeInfo(data:IDataInput)
      {
         super();
         var time:uint = uint(data.readUnsignedInt());
         this._date = new Date(time * 1000);
      }
      
      public function get date() : Date
      {
         return this._date;
      }
   }
}

