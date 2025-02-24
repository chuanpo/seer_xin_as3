package com.robot.core.info
{
   import flash.utils.IDataInput;
   
   public class ChangeUserNameInfo
   {
      private var _userId:uint;
      
      private var _nickName:String;
      
      public function ChangeUserNameInfo(data:IDataInput)
      {
         super();
         this._userId = data.readUnsignedInt();
         this._nickName = data.readUTFBytes(16);
      }
      
      public function get userId() : uint
      {
         return this._userId;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
   }
}

