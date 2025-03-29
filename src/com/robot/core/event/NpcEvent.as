package com.robot.core.event
{
   import com.robot.core.mode.NpcModel;
   import flash.events.Event;
   
   public class NpcEvent extends Event
   {
      public static const TASK_WITHOUT_DES:String = "taskWithoutDes";
      
      public static const NPC_CLICK:String = "npcClick";
      
      public static const SHOW_TASK_LIST:String = "showTaskList";
      
      public static const COMPLETE_TASK:String = "completeTask";

      public static const ORIGNAL_EVENT:String = "orignalEvent";
      
      private var _model:NpcModel;
      
      private var _taskID:uint;
      
      public function NpcEvent(type:String, model:NpcModel, taskID:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._model = model;
         this._taskID = taskID;
      }
      
      public function get model() : NpcModel
      {
         return this._model;
      }
      
      public function get taskID() : uint
      {
         return this._taskID;
      }
   }
}

