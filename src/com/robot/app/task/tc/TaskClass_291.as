package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_291
   {
      public function TaskClass_291(i:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(291,TasksManager.COMPLETE);
         ItemInBagAlert.show(400651,"1个谱尼的虚无裂片已经放入你的储存箱");
      }
   }
}

