package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_77
   {
      public function TaskClass_77(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(77,TasksManager.COMPLETE);
         ItemInBagAlert.show(400121,"1个赫德卡的精元已经放入你的储存箱");
      }
   }
}

