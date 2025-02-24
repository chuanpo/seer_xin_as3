package com.robot.core.info.task
{
   import flash.utils.IDataInput;
   
   public class MiningCountInfo
   {
      private var _miningCout:uint;
      
      public function MiningCountInfo(data:IDataInput)
      {
         super();
         this._miningCout = data.readUnsignedInt();
      }
      
      public function get miningCount() : uint
      {
         return this._miningCout;
      }
   }
}

