package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class PetKingPrizeInfo
   {
      private var _petID:uint;
      
      private var _catchTime:uint;
      
      public function PetKingPrizeInfo(data:IDataInput)
      {
         super();
         this._petID = data.readUnsignedInt();
         this._catchTime = data.readUnsignedInt();
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
   }
}

