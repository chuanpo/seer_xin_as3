package com.robot.core.info.mail
{
   import flash.utils.IDataInput;
   
   public class MailListInfo
   {
      private var _total:uint;
      
      private var _mailList:Array = [];
      
      public function MailListInfo(data:IDataInput)
      {
         super();
         this._total = data.readUnsignedInt();
         var count:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < count; i++)
         {
            this._mailList.push(new SingleMailInfo(data));
         }
      }
      
      public function get total() : uint
      {
         return this._total;
      }
      
      public function get mailList() : Array
      {
         return this._mailList;
      }
   }
}

