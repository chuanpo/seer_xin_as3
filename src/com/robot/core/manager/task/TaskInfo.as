package com.robot.core.manager.task
{
   public class TaskInfo
   {
      public var id:uint;
      
      public var pro:uint;
      
      public var callback:Function;
      
      public var outType:uint;
      
      public var status:Boolean;
      
      public var isComplete:Boolean;
      
      public var type:uint;
      
      public function TaskInfo(_id:uint, _pro:uint, _callback:Function)
      {
         super();
         this.id = _id;
         this.pro = _pro;
         this.callback = _callback;
      }
   }
}

