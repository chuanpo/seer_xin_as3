package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_55
   {
      public function TaskClass_55(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(55,TasksManager.COMPLETE);
         ItemInBagAlert.show(400112,"1个巴弗洛的精元已经放入你的储存箱");
      }
   }
}

