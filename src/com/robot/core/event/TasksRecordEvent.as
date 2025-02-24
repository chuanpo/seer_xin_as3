package com.robot.core.event
{
   import flash.events.Event;
   
   public class TasksRecordEvent extends Event
   {
      public static const SHOW_TASKSRECORDLISTPANEL:String = "showTasksRecordListPanel";
      
      public static const SHOW_TASKINTRODUCTION:String = "showTaskIntroductionPanel";
      
      public static const HIDE_TASKLISTPANEL:String = "hideTaskListPanel";
      
      private var _type:String;
      
      private var _data:Object;
      
      public function TasksRecordEvent(type:String, data:Object = null)
      {
         super(type);
         this._type = type;
         this._data = data;
      }
      
      public function get parameterObj() : Object
      {
         return this._data;
      }
   }
}

