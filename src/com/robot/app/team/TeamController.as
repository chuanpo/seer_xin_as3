package com.robot.app.team
{
   import com.robot.app.im.TeamChatController;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.team.SimpleTeamInfo;
   import com.robot.core.info.team.TeamAddInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.map.MapType;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class TeamController
   {
      private static var infoPanel:AppModel;
      
      private static var panel:AppModel;
      
      private static var searchPanel:MovieClip;
      
      private static var subMenu:MovieClip;
      
      public static const ADMIN:uint = 0;
      
      public static const MEMBER:uint = 1;
      
      public static const GUEST:uint = 2;
      
      public static const TEAM_INTEREST:Array = ["团结朋友","探索宇宙","精灵对战","对抗坏蛋","结识伙伴","维护正义","热爱自然","辛勤劳动","勤奋学习","公平竞争"];
      
      public static const ADMIN_STR:Array = ["指挥官","主将","副将","中坚","先锋","队员"];
      
      public function TeamController()
      {
         super();
      }
      
      public static function showSubMenu(o:DisplayObject) : void
      {
         var p:Point = null;
         var enterBtn:SimpleButton = null;
         var imBtn:SimpleButton = null;
         if(!subMenu)
         {
            subMenu = UIManager.getMovieClip("ui_teamBtnsPanel");
            p = o.localToGlobal(new Point());
            subMenu.x = p.x;
            subMenu.y = p.y - subMenu.height - 5;
            enterBtn = subMenu["enterTeamBtn"];
            imBtn = subMenu["teamImBtn"];
            ToolTipManager.add(enterBtn,"进入要塞");
            ToolTipManager.add(imBtn,"战队通迅");
            enterBtn.addEventListener(MouseEvent.CLICK,enterHandler);
            imBtn.addEventListener(MouseEvent.CLICK,imHandler);
         }
         LevelManager.topLevel.addChild(subMenu);
         MainManager.getStage().addEventListener(MouseEvent.CLICK,onStageClick);
      }
      
      private static function onStageClick(event:MouseEvent) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,onStageClick);
         if(!subMenu.hitTestPoint(event.stageX,event.stageY))
         {
            DisplayUtil.removeForParent(subMenu);
         }
      }
      
      private static function enterHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         show();
      }
      
      private static function imHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(subMenu);
         TeamChatController.show();
      }
      
      public static function show(teamID:uint = 0) : void
      {
         var id:uint = 0;
         if(teamID == 0)
         {
            id = uint(MainManager.actorInfo.teamInfo.id);
         }
         else
         {
            id = teamID;
         }
         if(id == 0)
         {
            searchTeam();
            return;
         }
         enter(id);
      }
      
      public static function searchTeam() : void
      {
         var closeBtn:SimpleButton = null;
         var okBtn:SimpleButton = null;
         if(!searchPanel)
         {
            searchPanel = new ui_findTeamAlarm();
            closeBtn = searchPanel["closeBtn"];
            okBtn = searchPanel["okBtn"];
            closeBtn.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
            {
               DisplayUtil.removeForParent(searchPanel);
            });
            okBtn.addEventListener(MouseEvent.CLICK,function(event:MouseEvent):void
            {
               var str:String = searchPanel["txt"].text;
               if(str.replace(/" "/g,"") == "")
               {
                  return;
               }
               search(uint(str));
               DisplayUtil.removeForParent(searchPanel);
            });
         }
         DisplayUtil.align(searchPanel,null,AlignType.MIDDLE_CENTER);
         LevelManager.appLevel.addChild(searchPanel);
      }
      
      private static function search(id:uint) : void
      {
         if(id <= 50000)
         {
            Alarm.show("战队不存在");
            return;
         }
         if(!SocketConnection.hasCmdListener(CommandID.TEAM_GET_INFO))
         {
            SocketConnection.addCmdListener(CommandID.TEAM_GET_INFO,function(event:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.TEAM_GET_INFO,arguments.callee);
               var info:SimpleTeamInfo = event.data as SimpleTeamInfo;
               show(info.teamID);
            });
         }
         SocketConnection.send(CommandID.TEAM_GET_INFO,id);
      }
      
      public static function create() : void
      {
         if(MainManager.actorInfo.teamInfo.id != 0)
         {
            Alarm.show("你已经加入了一个战队，如果想要创建一个战队的话，要先退出之前的战队哦！");
            return;
         }
         if(panel == null)
         {
            panel = ModuleManager.getModule(ClientConfig.getAppModule("TeamCreater"),"正在打开创建程序");
            panel.setup();
         }
         panel.show();
      }
      
      public static function join(id:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_ADD,onTeamAdd);
         SocketConnection.send(CommandID.TEAM_ADD,id);
      }
      
      private static function onTeamAdd(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_ADD,onTeamAdd);
         var data:TeamAddInfo = event.data as TeamAddInfo;
         if(data.ret == 0)
         {
            Alarm.show("恭喜你加入战队成功");
            MainManager.actorInfo.teamInfo.id = data.teamID;
            MainManager.actorInfo.teamInfo.priv = 5;
         }
         else if(data.ret == 1)
         {
            Alarm.show("你的申请已经提交，等待对方验证");
         }
         else
         {
            Alarm.show("对不起，该战队不允许任何人加入");
         }
      }
      
      public static function enter(id:uint) : void
      {
         if(id == 0)
         {
            Alarm.show("你还没有加入一个战队哦！");
            return;
         }
         MapManager.changeMap(id,0,MapType.CAMP);
      }
      
      public static function changePriv(uid:uint, priv:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_DELET_MEMBER,arguments.callee);
         SocketConnection.addCmdListener(CommandID.TEAM_CHANGE_ADMIN,function(event:SocketEvent):void
         {
            Alarm.show("调整成功");
            SocketConnection.removeCmdListener(CommandID.TEAM_CHANGE_ADMIN,arguments.callee);
         });
         SocketConnection.send(CommandID.TEAM_CHANGE_ADMIN,uid,priv);
      }
      
      public static function del(uid:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_DELET_MEMBER,arguments.callee);
         SocketConnection.addCmdListener(CommandID.TEAM_DELET_MEMBER,function(event:SocketEvent):void
         {
            Alarm.show("删除成功");
            SocketConnection.removeCmdListener(CommandID.TEAM_DELET_MEMBER,arguments.callee);
         });
         SocketConnection.send(CommandID.TEAM_DELET_MEMBER,uid);
      }
      
      public static function invite(uid:uint) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_INVITE_TO_JOIN,onInvite);
         SocketConnection.addCmdListener(CommandID.TEAM_INVITE_TO_JOIN,onInvite);
         SocketConnection.send(CommandID.TEAM_INVITE_TO_JOIN,uid);
      }
      
      private static function onInvite(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_INVITE_TO_JOIN,onInvite);
         Alarm.show("你的邀请已经发出，请耐心等待对方答复");
      }
   }
}

