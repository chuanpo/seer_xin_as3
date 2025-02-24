package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_51
   {
      public function TaskClass_51(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(51,TasksManager.COMPLETE);
         ItemInBagAlert.show(400110,"1个魔牙鲨的精元已经放入你的储存箱");
      }
   }
}

