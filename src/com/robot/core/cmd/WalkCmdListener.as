package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class WalkCmdListener extends BaseBeanController
   {
      public function WalkCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PEOPLE_WALK,this.onWalk);
         finish();
      }
      
      private function onWalk(e:SocketEvent) : void
      {
         var len:uint = 0;
         var wd:ByteArray = null;
         var by:ByteArray = e.data as ByteArray;
         by.position = 0;
         var type:uint = by.readUnsignedInt();
         var userID:uint = by.readUnsignedInt();
         var pos:Point = new Point(by.readUnsignedInt(),by.readUnsignedInt());
         if(userID != MainManager.actorInfo.userID)
         {
            len = 0;
            if(len == 0)
            {
               UserManager.dispatchAction(userID,PeopleActionEvent.WALK,pos);
            }
            else
            {
               wd = new ByteArray();
               by.readBytes(wd,0,len);
               UserManager.dispatchAction(userID,PeopleActionEvent.WALK,wd.readObject());
            }
         }
      }
   }
}

