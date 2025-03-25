package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class PetShowInfo
   {
      public var userID:uint;
      
      public var catchTime:uint;
      
      public var petID:uint;
      
      public var flag:uint;

      public var dv:uint;
      
      public var shiny:uint;

      public var skinID:uint;

      public function PetShowInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this.userID = data.readUnsignedInt();
            this.catchTime = data.readUnsignedInt();
            this.petID = data.readUnsignedInt();
            this.flag = data.readUnsignedInt();
            this.dv = data.readUnsignedInt();
            this.shiny = data.readUnsignedInt();
            this.skinID = data.readUnsignedInt();
            for(var index:int = 0; index < 3; index++)
            {
               data.readUnsignedInt();
            }
         }
      }
   }
}

