package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class TranUserCmdListener extends BaseBeanController
   {
      public function TranUserCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NOTE_TRANSFORM_USER,this.onTran);
         finish();
      }
      
      private function onTran(event:SocketEvent) : void
      {
         var people:BasePeoleModel = null;
         var by:ByteArray = event.data as ByteArray;
         var userID:uint = by.readUnsignedInt();
         var form:uint = by.readUnsignedInt();
         var time:uint = by.readUnsignedInt();
         if(userID == MainManager.actorID)
         {
            people = MainManager.actorModel;
         }
         else
         {
            people = UserManager.getUserModel(userID);
         }
         trace("---------------- We are~~~Transformers!!!");
         if(Boolean(people))
         {
         }
      }
   }
}

