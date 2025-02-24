package com.robot.core.cmd
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class SpringGiftNoticeCmdListener extends BaseBeanController
   {
      public function SpringGiftNoticeCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         finish();
      }
      
      private function onGigtNoticeHandler(e:SocketEvent) : void
      {
         var by:ByteArray = e.data as ByteArray;
         MainManager.actorInfo.coins = by.readUnsignedInt();
         MainManager.actorInfo.superNono = true;
         by.readUnsignedInt();
         NonoManager.info.superEnergy = by.readUnsignedInt();
         NonoManager.info.superLevel = by.readUnsignedInt();
         NonoManager.info.superStage = by.readUnsignedInt();
         MainManager.actorInfo.vipLevel = NonoManager.info.superLevel;
         MainManager.actorInfo.vipValue = NonoManager.info.superEnergy;
         MainManager.actorInfo.vipStage = NonoManager.info.superStage;
         if(Boolean(MainManager.actorModel.nono))
         {
            MainManager.actorModel.hideNono();
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
         }
      }
   }
}

