package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.relation.OnLineInfo;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.events.SocketEvent;
   
   public class UserInfoManager
   {
      public function UserInfoManager()
      {
         super();
      }
      
      public static function getInfo(id:uint, event:Function) : void
      {
         if(id == 0)
         {
            event(new UserInfo());
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_SIM_USERINFO,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_SIM_USERINFO,arguments.callee);
            var info:UserInfo = new UserInfo();
            UserInfo.setForSimpleInfo(info,e.data as IDataInput);
            event(info);
            if(RelationManager.isFriend(info.userID) || RelationManager.isBlack(info.userID))
            {
               RelationManager.upDateInfoForSimpleInfo(info);
            }
         });
         SocketConnection.send(CommandID.GET_SIM_USERINFO,id);
      }
      
      public static function upDateSimpleInfo(info:UserInfo, event:Function = null) : void
      {
         if(info.userID == 0)
         {
            if(event != null)
            {
               event();
            }
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_SIM_USERINFO,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_SIM_USERINFO,arguments.callee);
            UserInfo.setForSimpleInfo(info,e.data as IDataInput);
            if(event != null)
            {
               event();
            }
         });
         SocketConnection.send(CommandID.GET_SIM_USERINFO,info.userID);
      }
      
      public static function upDateMoreInfo(info:UserInfo, event:Function = null) : void
      {
         if(info.userID == 0)
         {
            if(event != null)
            {
               event();
            }
            return;
         }
         SocketConnection.addCmdListener(CommandID.GET_MORE_USERINFO,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.GET_MORE_USERINFO,arguments.callee);
            UserInfo.setForMoreInfo(info,e.data as IDataInput);
            if(event != null)
            {
               event();
            }
         });
         SocketConnection.send(CommandID.GET_MORE_USERINFO,info.userID);
      }
      
      public static function seeOnLine(ids:Array, event:Function) : void
      {
         var byd:ByteArray;
         var i:int;
         var arr:Array = null;
         arr = [];
         var len:int = int(ids.length);
         if(len == 0)
         {
            event(arr);
            return;
         }
         byd = new ByteArray();
         for(i = 0; i < len; i++)
         {
            byd.writeUnsignedInt(ids[i]);
         }
         SocketConnection.addCmdListener(CommandID.SEE_ONLINE,function(e:SocketEvent):void
         {
            var data:ByteArray = e.data as ByteArray;
            var len:uint = data.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               arr.push(new OnLineInfo(data));
            }
            event(arr);
            SocketConnection.removeCmdListener(CommandID.SEE_ONLINE,arguments.callee);
         });
         SocketConnection.send(CommandID.SEE_ONLINE,len,byd);
      }
   }
}

