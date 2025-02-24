package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class ExchangeOreInfo
   {
      private var _paiDou:uint;
      
      private var _oreCount:uint;
      
      public function ExchangeOreInfo(data:IDataInput)
      {
         super();
         this._oreCount = data.readUnsignedInt();
         this._paiDou = data.readUnsignedInt();
      }
      
      public function get paiDou() : uint
      {
         return this._paiDou;
      }
      
      public function get oreCount() : uint
      {
         return this._oreCount;
      }
   }
}

