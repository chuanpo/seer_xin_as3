package com.robot.app.info.item
{
   import flash.utils.IDataInput;
   
   public class BuyItemInfo
   {
      private var _cash:uint;
      
      private var _itemID:uint;
      
      private var _itemLevel:uint;
      
      private var _itemNum:uint;
      
      public function BuyItemInfo(data:IDataInput)
      {
         super();
         this._cash = data.readUnsignedInt();
         this._itemID = data.readUnsignedInt();
         this._itemNum = data.readUnsignedInt();
         this._itemLevel = data.readUnsignedInt();
      }
      
      public function get cash() : uint
      {
         return this._cash;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get itemLevel() : uint
      {
         return this._itemLevel;
      }
      
      public function get itemNum() : uint
      {
         return this._itemNum;
      }
   }
}

