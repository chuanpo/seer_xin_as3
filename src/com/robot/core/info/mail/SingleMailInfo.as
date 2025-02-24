package com.robot.core.info.mail
{
   import flash.utils.IDataInput;
   
   public class SingleMailInfo
   {
      private var _id:uint;
      
      public var template:uint;
      
      public var time:uint;
      
      public var fromID:uint;
      
      public var fromNick:String;
      
      private var _flag:uint;
      
      public var content:String;
      
      public function SingleMailInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this._id = data.readUnsignedInt();
            this.template = data.readUnsignedInt();
            this.time = data.readUnsignedInt();
            this.fromID = data.readUnsignedInt();
            this.fromNick = data.readUTFBytes(16);
            this._flag = data.readUnsignedInt();
         }
      }
      
      public function get readed() : Boolean
      {
         return this._flag == 1;
      }
      
      public function set readed(b:Boolean) : void
      {
         if(b)
         {
            this._flag = 1;
         }
         else
         {
            this._flag = 0;
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get date() : Date
      {
         var d:Date = new Date();
         d.setTime(this.time * 1000);
         return d;
      }
   }
}

