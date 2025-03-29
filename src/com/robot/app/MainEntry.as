package com.robot.app
{
   import com.robot.app.cmd.OfflineExpCmdListener;
   import com.robot.app.cmd.SysMsgCmdListener;
   import com.robot.core.CommandID;
   import com.robot.core.ErrorReport;
   import com.robot.core.cmd.ChatCmdListener;
   import com.robot.core.cmd.InformCmdListener;
   import com.robot.core.cmd.team.TeamInformCmdListener;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.controller.SaveUserInfo;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.RelationManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.mail.MailManager;
   import com.robot.core.manager.map.config.MapConfig;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.ByteArray;
   import org.taomee.component.manager.MComponentManager;
   import org.taomee.events.SocketErrorEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.TaomeeManager;
   import org.taomee.manager.TickManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.net.SocketDispatcher;
   
   public class MainEntry
   {
      public function MainEntry()
      {
         super();
      }
      
      public function setup(sprite:Sprite, ip:String, port:uint, userID:uint, session:ByteArray, relData:ByteArray, isSave:Boolean, pass:String) : void
      {
         MComponentManager.setup(sprite,14,"Tahoma");
         TaomeeManager.setup(sprite,sprite.stage);
         TaomeeManager.stageWidth = 960;
         TaomeeManager.stageHeight = 560;
         MainManager.actorID = userID;
         ItemXMLInfo.parseInfo();
         LevelManager.setup(sprite);
         ClassRegister.setup();
         TickManager.setup();
         RelationManager.init(relData);
         new OfflineExpCmdListener().start();
         new ChatCmdListener().start();
         new InformCmdListener().start();
         SysMsgCmdListener.getInstance().start();
         new TeamInformCmdListener().start();
         MailManager.setup();
         SocketConnection.mainSocket.userID = userID;
         SocketConnection.mainSocket.session = session;
         SocketConnection.mainSocket.ip = ip;
         SocketConnection.mainSocket.port = port;
         SocketConnection.mainSocket.addEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.mainSocket.connect(ip,port);
         SaveUserInfo.isSave = isSave;
         SaveUserInfo.pass = pass;
      }
      
      private function onConnect(e:Event) : void
      {
         SocketConnection.mainSocket.addEventListener(Event.CLOSE,this.socketClose);
         SocketConnection.mainSocket.removeEventListener(Event.CONNECT,this.onConnect);
         SocketConnection.addCmdListener(CommandID.LOGIN_IN,this.onLogin);
         SocketConnection.send(CommandID.LOGIN_IN,SocketConnection.mainSocket.session);
      }
      
      private function socketClose(event:Event) : void
      {
         var sprite:Sprite = null;
         trace("////////////////////////////////////////////////////////\r//\r//\t\t\t\t" + "socket was closed\r//\r////////////////////////////////////////////////////////");
         ErrorReport.sendError(ErrorReport.SOCKET_CLOSE_ERROR);
         try
         {
            sprite = Alarm.show("此次连接已经断开，请重新登陆",function():void
            {
               navigateToURL(new URLRequest("http://www.51seer.com"),"_self");
            },false,true);
            LevelManager.iconLevel.addChild(sprite);
         }
         catch(e:Error)
         {
         }
      }
      
      private function onLogin(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.LOGIN_IN,this.onLogin);
         SocketDispatcher.getInstance().addEventListener(SocketErrorEvent.ERROR,this.onError);
         EventManager.addEventListener(RobotEvent.CREATED_ACTOR,this.onCreatedActor);
         MainManager.setup(e.data);
         // MapConfig.setup();
      }
      
      private function onCreatedActor(event:RobotEvent) : void
      {
         EventManager.removeEventListener(RobotEvent.CREATED_ACTOR,this.onCreatedActor);
         ToolTipManager.setup(UIManager.getSprite("Tooltip_Background"));
         RelationManager.setup();
         SaveUserInfo.saveSo();
      }
      
      private function onError(event:SocketErrorEvent) : void
      {
         if(!event.headInfo)
         {
            ParseSocketError.parse(1,0);
         }
         else
         {
            ParseSocketError.parse(event.headInfo.result,event.headInfo.cmdID);
         }
      }
   }
}

