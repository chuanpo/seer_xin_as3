package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_59
   {
      public function TaskClass_59(i:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(59,TasksManager.COMPLETE);
         ItemInBagAlert.show(400115,"1个西萨拉斯的精元已经放入你的储存箱");
      }
   }
}

