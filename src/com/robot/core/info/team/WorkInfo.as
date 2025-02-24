package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class WorkInfo
   {
      public var buyTime:uint;
      
      public var id:uint;
      
      public var resID:uint;
      
      public var workCount:uint;
      
      public var totalRes:uint;
      
      public function WorkInfo(data:IDataInput)
      {
         super();
         this.buyTime = data.readUnsignedInt();
         this.id = data.readUnsignedInt();
         this.resID = data.readUnsignedInt();
         this.workCount = data.readUnsignedInt();
         this.totalRes = data.readUnsignedInt();
      }
   }
}

