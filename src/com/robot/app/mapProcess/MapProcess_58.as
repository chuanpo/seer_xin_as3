package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.CommandID;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.pet.PetBargeListInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class MapProcess_58 extends BaseMapProcess
   {
      public function MapProcess_58()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(FightInviteManager.isKillBigPetB1 == false)
         {
            SocketConnection.addCmdListener(CommandID.PET_BARGE_LIST,this.addCmListenrPet);
            SocketConnection.send(CommandID.PET_BARGE_LIST,229,229);
         }
      }
      
      private function addCmListenrPet(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.addCmListenrPet);
         var data:PetBargeListInfo = e.data as PetBargeListInfo;
         var arr:Array = data.isKillList;
         if(arr.length != 0)
         {
            FightInviteManager.isKillBigPetB1 = true;
         }
         else
         {
            EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
         }
      }
      
      private function onCloseFight(e:PetFightEvent) : void
      {
         var fightData:FightOverInfo = e.dataObj["data"];
         if(fightData.winnerID == MainManager.actorInfo.userID)
         {
            EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
            FightInviteManager.isKillBigPetB1 = true;
         }
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_BARGE_LIST,this.addCmListenrPet);
      }
   }
}

