package com.robot.core.info.transform
{
   import flash.utils.IDataInput;
   
   public class TransformInfo
   {
      private var _userID:uint;
      
      private var _changeShape:uint;
      
      public function TransformInfo(data:IDataInput)
      {
         super();
         this._userID = data.readUnsignedInt();
         this._changeShape = data.readUnsignedInt();
      }
      
      public function get isTransform() : Boolean
      {
         return this._changeShape != 0;
      }
      
      public function get suitID() : uint
      {
         return this._changeShape;
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
   }
}

