package com.robot.core.info.fightInfo
{
   import flash.utils.IDataInput;
   
   public class UsePetItemInfo
   {
      private var _userID:uint;
      
      private var _itemID:uint;
      
      private var _uesrHP:uint;
      
      public var changeHp:int;
      
      public function UsePetItemInfo(data:IDataInput)
      {
         super();
         this._userID = data.readUnsignedInt();
         this._itemID = data.readUnsignedInt();
         this._uesrHP = data.readUnsignedInt();
         this.changeHp = data.readInt();
      }
      
      public function get userID() : uint
      {
         return this._userID;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get userHP() : uint
      {
         return this._uesrHP;
      }
   }
}

