package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_56
   {
      public function TaskClass_56(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(56,TasksManager.COMPLETE);
         ItemInBagAlert.show(400113,"1个奇拉塔顿的精元已经放入你的储存箱");
      }
   }
}

