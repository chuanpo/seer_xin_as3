package com.robot.core.info.pet
{
   import flash.utils.IDataInput;
   
   public class PetTakeOutInfo
   {
      private var _homeEnergy:uint;
      
      private var _firstPetTime:uint;
      
      private var _flag:uint;
      
      private var _petInfo:PetInfo;
      
      public function PetTakeOutInfo(data:IDataInput)
      {
         super();
         this._homeEnergy = data.readUnsignedInt();
         this._firstPetTime = data.readUnsignedInt();
         this._flag = data.readUnsignedInt();
         if(this.flag != 0)
         {
            this._petInfo = new PetInfo(data);
         }
      }
      
      public function get homeEnergy() : uint
      {
         return this._homeEnergy;
      }
      
      public function get firstPetTime() : uint
      {
         return this._firstPetTime;
      }
      
      public function get flag() : uint
      {
         return this._flag;
      }
      
      public function get petInfo() : PetInfo
      {
         return this._petInfo;
      }
   }
}

