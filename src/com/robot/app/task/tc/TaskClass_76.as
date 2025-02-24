package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_76
   {
      public function TaskClass_76(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(76,TasksManager.COMPLETE);
         ItemInBagAlert.show(400120,"1个卡库的精元已经放入你的储存箱");
      }
   }
}

