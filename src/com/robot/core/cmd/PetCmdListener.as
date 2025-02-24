package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class PetCmdListener extends BaseBeanController
   {
      public function PetCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PET_SHOW,this.onPetShow);
         finish();
      }
      
      private function onPetShow(event:SocketEvent) : void
      {
         var data:PetShowInfo = event.data as PetShowInfo;
         if(data.flag == 1)
         {
            UserManager.dispatchAction(data.userID,PeopleActionEvent.PET_SHOW,data);
         }
         else
         {
            UserManager.dispatchAction(data.userID,PeopleActionEvent.PET_HIDE,data);
         }
      }
   }
}

