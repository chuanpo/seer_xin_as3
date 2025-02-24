package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_78
   {
      public function TaskClass_78(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(78,TasksManager.COMPLETE);
         ItemInBagAlert.show(400122,"1个伊兰罗尼的精元已经放入你的储存箱");
      }
   }
}

