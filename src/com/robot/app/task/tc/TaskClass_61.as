package com.robot.app.task.tc
{
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.ui.alert.PetInStorageAlert;
   
   public class TaskClass_61
   {
      private var info:NoviceFinishInfo;
      
      public function TaskClass_61(i:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(61,TasksManager.COMPLETE);
         this.info = i;
         this.getMilu();
      }
      
      private function getMilu() : void
      {
         PetManager.addEventListener(PetEvent.ADDED,function(e:PetEvent):void
         {
            PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
            PetInBagAlert.show(info.petID,"米鲁已经放入了你的精灵背包。");
         });
         if(PetManager.length < 6)
         {
            PetManager.setIn(this.info.captureTm,1);
         }
         else
         {
            PetInStorageAlert.show(this.info.petID,"米鲁已经放入了你的精灵仓库。");
            PetManager.addStorage(this.info.petID,this.info.captureTm);
         }
      }
   }
}

