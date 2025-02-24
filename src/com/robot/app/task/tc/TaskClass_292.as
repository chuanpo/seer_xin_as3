package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_292
   {
      public function TaskClass_292(i:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(292,TasksManager.COMPLETE);
         ItemInBagAlert.show(400652,"1个谱尼的元素裂片已经放入你的储存箱");
      }
   }
}

