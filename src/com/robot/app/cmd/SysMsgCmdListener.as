package com.robot.app.cmd
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.cmd.VipCmdListener;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.info.SystemMsgInfo;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class SysMsgCmdListener
   {
      private static var owner:SysMsgCmdListener;
      
      public static var npcLink:Array = [""];
      
      public static var npcName:Array = ["","船长罗杰","机械师茜茜","博士派特","导航员爱丽丝","站长贾斯汀","诺诺","发明家肖恩"];
      
      private static const FIRST_OPEN:uint = 1;
      
      private static const OPEN_AGAIN:uint = 2;
      
      private static const CANCEL:uint = 3;
      
      private static const NONO_UPDATE:uint = 4;
      
      private var panel:MovieClip;
      
      private var npcMC:Sprite;
      
      private var icon:SimpleButton;
      
      private var isBeanOver:Boolean = false;
      
      private var msgArray:Array = [];
      
      private var newYearPanel:MovieClip;
      
      private var morePanel:AppModel;
      
      private var npcArary:Array = ["","主播纽斯","船长罗杰","博士派特","精灵学者迪恩","唔理哇啦","百事通罗开","工程是苏克","叽哩呱啦","机械师茜茜","总教官雷蒙","发明家肖恩","站长贾斯汀"];
      
      private var mapArary:Array = ["","传送舱","船长室","实验室","资料室","去瞭望舱","瞭望露台","动力室","瞭望露台","机械室","教官办公室","发明室","精灵太空站"];
      
      public function SysMsgCmdListener()
      {
         super();
      }
      
      public static function getInstance() : SysMsgCmdListener
      {
         if(!owner)
         {
            owner = new SysMsgCmdListener();
         }
         return owner;
      }
      
      public function addInfo(info:SystemMsgInfo) : void
      {
         this.msgArray.push(info);
         this.checkLength();
      }
      
      public function start() : void
      {
         npcLink.push(NpcTipDialog.SHIPER);
         npcLink.push(NpcTipDialog.CICI);
         npcLink.push(NpcTipDialog.DOCTOR);
         npcLink.push(NpcTipDialog.IRIS);
         npcLink.push(NpcTipDialog.JUSTIN);
         npcLink.push(NpcTipDialog.NONO);
         npcLink.push(NpcTipDialog.SHAWN);
         npcLink.push(NpcTipDialog.ROCKY);
         SocketConnection.addCmdListener(CommandID.SYSTEM_MESSAGE,this.onSystemMsg);
         EventManager.addEventListener(RobotEvent.BEAN_COMPLETE,this.onBeanOver);
         EventManager.addEventListener(VipCmdListener.BE_VIP,this.onBeVip);
         EventManager.addEventListener(VipCmdListener.FIRST_VIP,this.onBeVip);
         SocketConnection.addCmdListener(CommandID.VIP_LEVEL_UP,this.onVipLevelUp);
      }
      
      private function onVipLevelUp(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         var stage:uint = data.readUnsignedInt();
         if(stage > 4)
         {
            stage = 4;
         }
      }
      
      private function onBeVip(event:Event) : void
      {
         this.onOpen(null);
      }
      
      private function onOpen(event:SocketEvent) : void
      {
         var info:NonoInfo = null;
         if(Boolean(MainManager.actorModel.nono))
         {
            info = MainManager.actorModel.nono.info;
            info.superNono = true;
            MainManager.actorModel.hideNono();
            MainManager.actorModel.showNono(info,MainManager.actorInfo.actionType);
         }
         if(Boolean(NonoManager.info))
         {
            NonoManager.info.superNono = true;
            NonoManager.info.power = 100;
            NonoManager.info.mate = 100;
         }
      }
      
      private function onBeanOver(event:Event) : void
      {
         this.isBeanOver = true;
         this.checkLength();
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,this.onSysTime);
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private function onSysTime(event:SocketEvent) : void
      {
         var so:SharedObject = null;
         var info:SystemMsgInfo = null;
         SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,this.onSysTime);
         var date:Date = (event.data as SystemTimeInfo).date;
         if(date.getDay() == 5 && ClientConfig.uiVersion != SOManager.getUser_Info().data["nonoExp"] && Boolean(MainManager.actorInfo.hasNono))
         {
            so = SOManager.getUser_Info();
            so.data["nonoExp"] = ClientConfig.uiVersion;
            SOManager.flush(so);
            info = new SystemMsgInfo();
            info.npc = 7;
            info.msgTime = date.getTime() / 1000;
            info.msg = "    你的" + MainManager.actorInfo.nonoNick + "周全照顾使精灵们积累了额外的经验奖励，快去发明室的经验接收器那里领取本周的奖励吧！";
            this.msgArray.push(info);
            this.checkLength();
         }
      }
      
      private function onSystemMsg(event:SocketEvent) : void
      {
         var data:SystemMsgInfo = event.data as SystemMsgInfo;
         this.msgArray.push(data);
         if(this.isBeanOver)
         {
            this.checkLength();
         }
      }
      
      private function checkLength() : void
      {
         var cls:VipNotManager = null;
         if(!this.isBeanOver)
         {
            return;
         }
         if(this.msgArray.length == 0)
         {
            this.hideIcon();
            return;
         }
         var data:SystemMsgInfo = this.msgArray[0];
         if(data.type == FIRST_OPEN || data.type == OPEN_AGAIN || data.type == CANCEL || data.type == NONO_UPDATE)
         {
            data = this.msgArray.shift() as SystemMsgInfo;
            cls = new VipNotManager();
            if(data.type == FIRST_OPEN)
            {
               cls.goNow(data);
            }
            else if(data.type == OPEN_AGAIN || data.type == NONO_UPDATE)
            {
               cls.openAgain(data);
            }
            else if(data.type == CANCEL)
            {
               cls.cancelHandler(data);
            }
            this.checkLength();
            return;
         }
         if(this.msgArray.length > 0)
         {
            this.showIcon();
         }
         else if(this.msgArray.length == 0)
         {
            this.hideIcon();
         }
      }
      
      private function showIcon() : void
      {
         if(!this.icon)
         {
            this.icon = UIManager.getButton("System_Msg_Icon");
            this.icon.x = 118 + 70;
            this.icon.y = 20;
            this.icon.addEventListener(MouseEvent.CLICK,this.showSysMsg);
         }
         LevelManager.iconLevel.addChild(this.icon);
      }
      
      private function hideIcon() : void
      {
         DisplayUtil.removeForParent(this.icon);
      }
      
      private function showSysMsg(event:MouseEvent) : void
      {
         var data:SystemMsgInfo;
         var date:Date = null;
         var str:String = null;
         if(!this.panel)
         {
            this.panel = this.getPanel();
            this.newYearPanel = this.getNewYearPanel();
         }
         data = this.msgArray.shift() as SystemMsgInfo;
         if(!data.isNewYear)
         {
            this.panel["titleTxt"].text = "亲爱的" + MainManager.actorInfo.nick;
            this.panel["msgTxt"].htmlText = data.msg;
            date = new Date(data.msgTime * 1000);
            str = npcName[data.npc] + "\r";
            this.panel["timeTxt"].text = str + date.getFullYear() + "年" + (date.getMonth() + 1) + "月" + date.getDate() + "日";
            ResourceManager.getResource(ClientConfig.getNpcSwfPath(npcLink[data.npc]),function(o:DisplayObject):void
            {
               npcMC.addChild(o);
            },"npc");
            LevelManager.appLevel.addChild(this.panel);
         }
         else
         {
            this.showNewYearInfo(data);
         }
         this.checkLength();
      }
      
      private function getPanel() : MovieClip
      {
         var mc:MovieClip = UIManager.getMovieClip("ui_SysMsg_Panel");
         var closeBtn:SimpleButton = mc["closeBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.npcMC = new Sprite();
         this.npcMC.scaleY = 0.65;
         this.npcMC.scaleX = 0.65;
         this.npcMC.x = 50;
         this.npcMC.y = 86;
         mc.addChild(this.npcMC);
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
         return mc;
      }
      
      private function getNewYearPanel() : MovieClip
      {
         var mc:MovieClip = new lib_year_note();
         var closeBtn:SimpleButton = mc["closeBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,this.closeNewYearHandler);
         var moreBtn:MovieClip = mc["moreBtn"];
         var openBtn:MovieClip = mc["openBtn"];
         openBtn.buttonMode = true;
         moreBtn.buttonMode = true;
         moreBtn.addEventListener(MouseEvent.CLICK,this.onMoreHandler);
         openBtn.addEventListener(MouseEvent.CLICK,this.onOpenHandler);
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
         return mc;
      }
      
      private function onMoreHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.newYearPanel,false);
         if(!this.morePanel)
         {
            this.morePanel = new AppModel(ClientConfig.getAppModule("CongratulatePanel"),"正在打开...");
            this.morePanel.setup();
         }
         this.morePanel.show();
      }
      
      private function onOpenHandler(event:MouseEvent) : void
      {
         var r:VipSession = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
         {
         });
         r.getSession();
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.panel,false);
         DisplayUtil.removeAllChild(this.npcMC);
      }
      
      private function closeNewYearHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.newYearPanel,false);
      }
      
      private function showNewYearInfo(data:SystemMsgInfo) : void
      {
         SOManager.getUser_Info().data["isReadMsg"] = ClientConfig.newsVersion;
         this.newYearPanel["txt"].htmlText = data.msg;
         LevelManager.appLevel.addChild(this.newYearPanel);
      }
   }
}

