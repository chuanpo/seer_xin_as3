package com.robot.core.info.team
{
   import flash.utils.IDataInput;
   
   public class DonateInfo
   {
      public var buyTime:uint;
      
      public var id:uint;
      
      public var resID:uint;
      
      public var donateCount:uint;
      
      public var totalRes:uint;
      
      public function DonateInfo(data:IDataInput)
      {
         super();
         this.buyTime = data.readUnsignedInt();
         this.id = data.readUnsignedInt();
         this.resID = data.readUnsignedInt();
         this.donateCount = data.readUnsignedInt();
         this.totalRes = data.readUnsignedInt();
      }
   }
}

