package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class PetListInfo
   {
      public var id:uint;
      
      public var catchTime:uint;
      
      public var course:uint;

      public var level:uint;

      public var skinID:uint;

      public var shiny:uint;
      
      public function PetListInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this.id = data.readUnsignedInt();
            this.catchTime = data.readUnsignedInt();
            this.level = data.readUnsignedInt();
            this.skinID = data.readUnsignedInt();
            this.shiny = data.readUnsignedInt();
         }
      }
   }
}

