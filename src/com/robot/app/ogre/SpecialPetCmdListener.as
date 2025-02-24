package com.robot.app.ogre
{
   import com.robot.app.mapProcess.active.SpecialPetActive;
   import com.robot.core.CommandID;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class SpecialPetCmdListener extends BaseBeanController
   {
      public function SpecialPetCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.SPECIAL_PET_NOTE,this.onSpecialList);
         finish();
      }
      
      private function onSpecialList(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var flag:uint = data.readUnsignedInt();
         var monID:uint = data.readUnsignedInt();
         if(flag == 1)
         {
            SpecialPetActive.show(monID);
         }
         else
         {
            SpecialPetActive.hide();
         }
      }
   }
}

