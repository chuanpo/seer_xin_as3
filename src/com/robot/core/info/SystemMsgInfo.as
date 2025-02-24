package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class SystemMsgInfo
   {
      public var isNewYear:Boolean = false;
      
      public var npc:uint;
      
      public var msgTime:uint;
      
      private var msgLen:uint;
      
      public var msg:String;
      
      public var type:uint;
      
      public function SystemMsgInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this.type = data.readShort();
            this.npc = data.readShort();
            this.msgTime = data.readUnsignedInt();
            this.msgLen = data.readUnsignedInt();
            this.msg = data.readUTFBytes(this.msgLen);
         }
      }
   }
}

