package com.robot.core.info.fightInfo
{
   import flash.utils.IDataInput;
   
   public class CatchPetInfo
   {
      private var _catchTime:uint;
      
      private var _petID:uint;
      
      public function CatchPetInfo(data:IDataInput)
      {
         super();
         this._catchTime = data.readUnsignedInt();
         this._petID = data.readUnsignedInt();
      }
      
      public function get catchTime() : uint
      {
         return this._catchTime;
      }
      
      public function get petID() : uint
      {
         return this._petID;
      }
   }
}

