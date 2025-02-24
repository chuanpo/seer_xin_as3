package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class MiningInfo
   {
      private var _oreCount:uint;
      
      public function MiningInfo(data:IDataInput)
      {
         super();
         this._oreCount = data.readUnsignedInt();
      }
      
      public function get oreCount() : uint
      {
         return this._oreCount;
      }
   }
}

