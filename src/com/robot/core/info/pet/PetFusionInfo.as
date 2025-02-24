package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class PetFusionInfo
   {
      public var obtainTime:uint;
      
      public var soulID:uint;
      
      public var starterCpTm:uint;
      
      public var costItemFlag:uint;
      
      public function PetFusionInfo(data:IDataInput)
      {
         super();
         this.obtainTime = data.readUnsignedInt();
         this.soulID = data.readUnsignedInt();
         this.starterCpTm = data.readUnsignedInt();
         this.costItemFlag = data.readUnsignedInt();
      }
   }
}

