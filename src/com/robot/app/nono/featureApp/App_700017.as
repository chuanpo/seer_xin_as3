package com.robot.app.nono.featureApp
{
   import com.robot.core.CommandID;
   import com.robot.core.aticon.FlyAction;
   import com.robot.core.aticon.PeculiarAction;
   import com.robot.core.aticon.WalkAction;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.EmptySkeletonStrategy;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.nono.NonoShortcut;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class App_700017
   {
      public function App_700017(id:uint)
      {
         super();
         if(MainManager.actorModel.isTransform)
         {
            Alarm.show("你目前处在变身状态不可以飞行！");
            return;
         }
         var tt:uint = uint(MainManager.actorInfo.actionType);
         SocketConnection.addCmdListener(CommandID.ON_OR_OFF_FLYING,this.onFlyHandler);
         if(MainManager.actorInfo.actionType == 0)
         {
            SocketConnection.send(CommandID.ON_OR_OFF_FLYING,1);
         }
         else
         {
            SocketConnection.send(CommandID.ON_OR_OFF_FLYING,0);
         }
      }
      
      private function onFlyHandler(e:SocketEvent) : void
      {
         NonoShortcut.onNonoPanelClose(null);
         SocketConnection.removeCmdListener(CommandID.ON_OR_OFF_FLYING,this.onFlyHandler);
         var by:ByteArray = e.data as ByteArray;
         var ty:uint = by.readUnsignedInt();
         MainManager.actorInfo.actionType = ty;
         MainManager.actorModel.hideNono();
         if(ty == 0)
         {
            MainManager.actorInfo.nonoState[1] = false;
            MainManager.actorModel.walk = new WalkAction();
            MainManager.actorModel.footMC.visible = true;
            new PeculiarAction().standUp(MainManager.actorModel.skeleton as EmptySkeletonStrategy);
            MainManager.actorModel.nameTxt.y -= 40;
         }
         else
         {
            NonoManager.dispatchEvent(new NonoEvent(NonoEvent.FOLLOW,NonoManager.info));
            MainManager.actorInfo.nonoState[1] = true;
            MainManager.actorModel.walk = new FlyAction(MainManager.actorModel);
         }
         MainManager.actorModel.showNono(NonoManager.info,ty);
      }
   }
}

