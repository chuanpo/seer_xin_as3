package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.aticon.PeculiarAction;
   import com.robot.core.aticon.WalkAction;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.EmptySkeletonStrategy;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class FollowCmdListener extends BaseBeanController
   {
      public function FollowCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_FOLLOW_OR_HOOM,this.onChanged);
         finish();
      }
      
      private function onChanged(e:SocketEvent) : void
      {
         var info:NonoInfo = null;
         var peo:BasePeoleModel = null;
         var data:ByteArray = e.data as ByteArray;
         var id:uint = data.readUnsignedInt();
         var stage:uint = data.readUnsignedInt();
         var flag:Boolean = Boolean(data.readUnsignedInt());
         if(Boolean(NonoManager.info))
         {
            if(NonoManager.info.userID == id)
            {
               NonoManager.info.state[1] = flag;
            }
         }
         if(flag)
         {
            info = new NonoInfo();
            info.userID = id;
            info.superStage = stage;
            info.nick = data.readUTFBytes(16);
            info.color = data.readUnsignedInt();
            info.power = data.readUnsignedInt() / 1000;
            if(MainManager.actorID == id)
            {
               if(Boolean(NonoManager.info))
               {
                  NonoManager.info.power = info.power;
                  info = NonoManager.info;
               }
               else
               {
                  info.superNono = MainManager.actorInfo.superNono;
                  NonoManager.info = info;
               }
            }
            else
            {
               peo = UserManager.getUserModel(id);
               if(Boolean(peo))
               {
                  info.superNono = peo.info.superNono;
               }
            }
            UserManager.dispatchAction(id,PeopleActionEvent.NONO_FOLLOW,info);
            NonoManager.dispatchEvent(new NonoEvent(NonoEvent.FOLLOW,info));
         }
         else
         {
            UserManager.dispatchAction(id,PeopleActionEvent.NONO_HOOM,flag);
            NonoManager.dispatchEvent(new NonoEvent(NonoEvent.HOOM,null));
            if(MainManager.actorInfo.actionType == 1)
            {
               MainManager.actorModel.walk = new WalkAction();
               MainManager.actorInfo.nonoState[1] = false;
               MainManager.actorModel.footMC.visible = true;
               new PeculiarAction().standUp(MainManager.actorModel.skeleton as EmptySkeletonStrategy);
               MainManager.actorModel.nameTxt.y -= 40;
               MainManager.actorInfo.actionType = 0;
            }
         }
      }
   }
}

