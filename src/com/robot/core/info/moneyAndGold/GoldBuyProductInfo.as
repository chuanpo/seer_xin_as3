package com.robot.core.info.moneyAndGold
{
   import flash.utils.IDataInput;
   
   public class GoldBuyProductInfo
   {
      private var _payGold:Number;
      
      private var _gold:Number;
      
      public function GoldBuyProductInfo(data:IDataInput)
      {
         super();
         data.readUnsignedInt();
         this._payGold = data.readUnsignedInt() / 100;
         this._gold = data.readUnsignedInt() / 100;
      }
      
      public function get payGold() : Number
      {
         return this._payGold;
      }
      
      public function get gold() : Number
      {
         return this._gold;
      }
   }
}

