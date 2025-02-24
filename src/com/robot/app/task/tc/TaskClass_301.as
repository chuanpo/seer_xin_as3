package com.robot.app.task.tc
{
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.ui.alert.PetInStorageAlert;
   
   public class TaskClass_301
   {
      public function TaskClass_301(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(301,TasksManager.COMPLETE);
         PetManager.addEventListener(PetEvent.ADDED,function(e:PetEvent):void
         {
            PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
            PetInBagAlert.show(info.petID,"你的精灵真勇敢，成功制服了蘑菇怪兽。作为先锋队奖励，一个小蘑菇已经放入你的精灵包了。快去好好训练它吧！",LevelManager.iconLevel);
         });
         if(PetManager.length < 6)
         {
            PetManager.setIn(info.captureTm,1);
         }
         else
         {
            PetManager.addStorage(info.petID,info.captureTm);
            PetInStorageAlert.show(info.petID,"你的精灵真勇敢，成功制服了蘑菇怪兽。作为先锋队奖励，一个小蘑菇已经放入你的精灵仓库了。快去好好训练它吧！",LevelManager.iconLevel);
         }
      }
   }
}

