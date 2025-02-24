package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_293
   {
      public function TaskClass_293(i:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(293,TasksManager.COMPLETE);
         ItemInBagAlert.show(400653,"谱尼的能量裂片已经放入你的储存箱");
      }
   }
}

