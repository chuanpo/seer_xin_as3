package com.robot.core.info.userItem
{
   import com.robot.core.utils.ItemType;
   import flash.utils.IDataInput;
   
   public class SingleItemInfo
   {
      private var _itemID:uint;
      
      private var _itemLevel:uint;
      
      public var itemNum:uint;
      
      public var leftTime:uint;
      
      public var type:uint;
      
      public function SingleItemInfo(data:IDataInput = null)
      {
         super();
         if(Boolean(data))
         {
            this.itemID = data.readUnsignedInt();
            this.itemNum = data.readUnsignedInt();
            this.leftTime = data.readUnsignedInt();
            this._itemLevel = data.readUnsignedInt();
         }
      }
      
      public function set itemID(v:uint) : void
      {
         this._itemID = v;
         if(this._itemID >= 100001 && this._itemID <= 101001)
         {
            this.type = ItemType.CLOTH;
         }
         else if(this._itemID >= 200001 && this._itemID <= 300000)
         {
            this.type = ItemType.DOODLE;
         }
         else if(this._itemID >= 300001 && this._itemID <= 400000)
         {
            this.type = ItemType.PET_PROPERTY;
         }
         else if(this._itemID >= 400001 && this._itemID <= 500000)
         {
            this.type = ItemType.COLLECTON;
         }
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      public function get itemLevel() : uint
      {
         return this._itemLevel;
      }
   }
}

