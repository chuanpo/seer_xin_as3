package com.robot.core.info.pet.update
{
   import flash.utils.IDataInput;
   
   public class PetUpdatePropInfo
   {
      private var _addition:uint;
      
      private var _dataArray:Array = [];
      
      public function PetUpdatePropInfo(data:IDataInput)
      {
         super();
         this._addition = data.readUnsignedInt();
         var count:uint = uint(data.readUnsignedInt());
         for(var i:uint = 0; i < count; i++)
         {
            this._dataArray.push(new UpdatePropInfo(data));
         }
      }
      
      public function get dataArray() : Array
      {
         return this._dataArray;
      }
      
      public function get addition() : Number
      {
         return this._addition / 100;
      }
      
      public function get addPer() : uint
      {
         return this._addition;
      }
   }
}

