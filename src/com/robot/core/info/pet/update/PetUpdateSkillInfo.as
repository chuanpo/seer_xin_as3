package com.robot.core.info.pet.update
{
   import flash.utils.IDataInput;
   
   public class PetUpdateSkillInfo
   {
      private var _infoArray:Array = [];
      
      public function PetUpdateSkillInfo(data:IDataInput)
      {
         super();
         var petNum:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < petNum; i++)
         {
            this._infoArray.push(new UpdateSkillInfo(data));
         }
      }
      
      public function get infoArray() : Array
      {
         return this._infoArray;
      }
   }
}

