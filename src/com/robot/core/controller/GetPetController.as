package com.robot.core.controller
{
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetEvent;
   import com.robot.core.manager.PetManager;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.ui.alert.PetInStorageAlert;
   
   public class GetPetController
   {
      public function GetPetController()
      {
         super();
      }
      
      public static function getPet(monID:uint, captureTm:uint) : void
      {
         PetManager.addEventListener(PetEvent.ADDED,function(e:PetEvent):void
         {
            PetManager.removeEventListener(PetEvent.ADDED,arguments.callee);
            PetInBagAlert.show(monID,PetXMLInfo.getName(monID) + "已经放入了你的精灵背包。");
         });
         if(PetManager.length < 6)
         {
            PetManager.setIn(captureTm,1);
         }
         else
         {
            PetManager.addStorage(monID,captureTm);
            PetInStorageAlert.show(monID,PetXMLInfo.getName(monID) + "已经放入了你的精灵仓库。");
         }
      }
   }
}

