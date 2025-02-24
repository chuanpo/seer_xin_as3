package com.robot.core.info.fightInfo
{
   import flash.utils.IDataInput;
   
   public class FighetUserInfo
   {
      private var _id:uint;
      
      private var _nickName:String;
      
      public function FighetUserInfo(data:IDataInput)
      {
         super();
         this._id = data.readUnsignedInt();
         this._nickName = data.readUTFBytes(16);
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
   }
}

