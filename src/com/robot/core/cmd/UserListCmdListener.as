package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.aticon.FlyAction;
   import com.robot.core.aticon.WalkAction;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.manager.map.MapType;
   import com.robot.core.mode.PeopleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.teamPK.TeamPKManager;
   import com.robot.core.teamPK.shotActive.PKInteractiveAction;
   import com.robot.core.utils.Direction;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class UserListCmdListener extends BaseBeanController
   {
      public static var superList:Array = [];
      
      public function UserListCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.LIST_MAP_PLAYER,this.onUserList);
         finish();
      }
      
      private function onUserList(e:SocketEvent) : void
      {
         var info:UserInfo = null;
         var user:PeopleModel = null;
         var by:ByteArray = e.data as ByteArray;
         by.position = 0;
         var len:uint = by.readUnsignedInt();
         superList = [];
         for(var i:int = 0; i < len; i++)
         {
            info = new UserInfo();
            UserInfo.setForPeoleInfo(info,by);
            info.serverID = MainManager.serverID;
            if(info.userID != MainManager.actorInfo.userID)
            {
               user = new PeopleModel(info);
               if(info.actionType == 0)
               {
                  user.walk = new WalkAction();
               }
               else
               {
                  user.walk = new FlyAction(user);
               }
               MapManager.currentMap.addUser(user);
               if(MainManager.actorInfo.mapType == MapType.PK_TYPE)
               {
                  if(info.teamInfo.id != MainManager.actorInfo.mapID)
                  {
                     user.additiveInfo.info = TeamPKManager.AWAY;
                  }
                  else
                  {
                     user.additiveInfo.info = TeamPKManager.HOME;
                  }
                  user.interactiveAction = new PKInteractiveAction(user);
               }
            }
            else if(Boolean(MainManager.actorModel.nono))
            {
               MainManager.actorModel.nono.direction = Direction.DOWN;
            }
            if(info.teamInfo.coreCount >= 10 && info.teamInfo.isShow)
            {
               superList.push(info.userID);
            }
         }
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.FILTER_SUPER_TEAM));
         EventManager.dispatchEvent(new RobotEvent(RobotEvent.CREATED_MAP_USER));
      }
   }
}

