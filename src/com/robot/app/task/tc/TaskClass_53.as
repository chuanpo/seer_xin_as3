package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_53
   {
      public function TaskClass_53(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(53,TasksManager.COMPLETE);
         ItemInBagAlert.show(400111,"1个贝鲁基德的精元已经放入你的储存箱");
      }
   }
}

