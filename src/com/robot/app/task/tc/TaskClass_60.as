package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_60
   {
      public function TaskClass_60(i:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(59,TasksManager.COMPLETE);
         ItemInBagAlert.show(400116,"1个克林卡修的精元已经放入你的储存箱");
      }
   }
}

