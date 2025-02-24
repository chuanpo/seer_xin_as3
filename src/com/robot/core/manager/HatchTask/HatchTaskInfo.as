package com.robot.core.manager.HatchTask
{
   public class HatchTaskInfo
   {
      public var outType:uint;
      
      public var isComplete:Boolean = false;
      
      public var type:uint;
      
      public var obtainTime:uint;
      
      public var statusList:Array;
      
      public var itemID:uint;
      
      public var callback:Function;
      
      public function HatchTaskInfo(obtainTm:uint, itemId:uint, sl:Array, callbk:Function = null)
      {
         super();
         this.obtainTime = obtainTm;
         this.itemID = itemId;
         this.statusList = sl;
         this.callback = callbk;
      }
   }
}

