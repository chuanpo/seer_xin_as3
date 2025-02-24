package com.robot.app.info.fightInvite
{
   import flash.utils.IDataInput;
   
   public class InviteNoteInfo
   {
      private var _userID:uint;
      
      private var _nickName:String;
      
      private var _mode:uint;
      
      public function InviteNoteInfo(data:IDataInput)
      {
         super();
         this._userID = data.readUnsignedInt();
         this._nickName = data.readUTFBytes(16);
         this._mode = data.readUnsignedInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get nickName() : String
      {
         return this._nickName;
      }
      
      public function get mode() : uint
      {
         return this._mode;
      }
   }
}

