package com.robot.app.info.item
{
   import flash.utils.IDataInput;
   
   public class BuyMultiItemInfo
   {
      private var _cash:uint;
      
      public function BuyMultiItemInfo(data:IDataInput)
      {
         super();
         this._cash = data.readUnsignedInt();
      }
      
      public function get cash() : uint
      {
         return this._cash;
      }
   }
}

