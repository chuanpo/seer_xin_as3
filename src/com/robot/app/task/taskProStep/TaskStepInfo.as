package com.robot.app.task.taskProStep
{
   public class TaskStepInfo
   {
      public var taskID:uint;
      
      public var pro:uint;
      
      public var stepID:uint = 0;
      
      public var mapID:uint = 0;
      
      public var stepType:uint = 0;
      
      public var goto1:Array = [];
      
      public var isComplete:Boolean = false;
      
      public function TaskStepInfo(taskId:uint, p:uint, mapId:uint, stepXML:XML = null)
      {
         super();
         this.taskID = taskId;
         this.pro = p;
         this.mapID = mapId;
         if(Boolean(stepXML))
         {
            this.stepID = stepXML.@id;
            this.stepType = stepXML.@type;
            this.goto1 = String(stepXML["@goto"]).split("_");
         }
      }
   }
}

