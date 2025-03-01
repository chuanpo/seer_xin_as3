package com.robot.app.mapProcess
{
   import com.robot.app.energy.ore.DayOreCount;
   import com.robot.app.nono.GetNoNo;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.energyExchange.ExchangeOreModel;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_107 extends BaseMapProcess
   {
      public static var isOpenSuperNoNo:Boolean = false;
      
      private var type:uint;
      
      private var _nonoBookSo:SharedObject;
      
      private var _nonoChipSo:SharedObject;
      
      private var _nonoSuperSo:SharedObject;
      
      private var _nonoBookBtn:MovieClip;
      
      private var _nonoMixBookBtn:MovieClip;
      
      private var _tipMc:MovieClip;
      
      private var _panelApp:AppModel;
      
      private var npc:NpcModel;
      
      private var b1:Boolean = false;
      
      private var questionPanel:AppModel;
      
      private var _xinpianApp:AppModel;
      
      private var timer:Timer;
      
      private var timerIndex:uint;
      
      private var wordArr:Array = ["大家好，我是人见人爱、花见花开的可爱NoNo","有什么问题就来找我吧，我肯定可以帮我全部解答","传说中的超能NoNo是我们伟大的肖恩老师发明的哦！","想知道肖恩老师最近有什么新发明吗？"];
      
      private var introlWordArr:Array = [{
         "mc":"getNoNoBtn",
         "word":"<font color=\'#ff0000\'>NoNo领取处</font>是每个小赛尔领取属于自己的NoNo的地方，每个小赛尔只能拥有一个NoNo，要好好珍惜它哦！想要更加了解NoNo就看旁边的NoNo手册吧！"
      },{
         "mc":"chipMixMc",
         "word":"<font color=\'#ff0000\'>芯片制造机</font>是合成NoNo芯片的专用仪器。参照芯片合成手册的相关配方，在这里进行NoNo所需芯片的合成制造。用不正确的配方无法得到你想要的芯片哦，一定要看清配方呢！"
      },{
         "mc":"joinMachineMC",
         "word":"<font color=\'#ff0000\'>超能融合机</font>是台伟大的仪器哦，使用了超能晶体的神奇能量，激发NoNo们的潜力，将普通NoNo进化成像我这样聪明灵巧的超能NoNo。快带你的NoNo来体验一下吧！"
      },{
         "mc":"nonoStage",
         "word":"<font color=\'#ff0000\'>超能试验台</font>是肖恩老师每天彻夜奋战的地方，一个个伟大的发明就是从这里诞生的！"
      },{
         "mc":"analyzeMachineMC",
         "word":"<font color=\'#ff0000\'>超能分析仪</font>可以分析各种的超能晶体，对这些珍贵的晶体进行分类和能量激发。目前我们可以从这里领取经过超能激发的精灵胶囊，比一般的精灵胶囊的精灵捕捉概率高了很多呢。"
      },{
         "mc":"getExpBtn",
         "word":"<font color=\'#ff0000\'>经验接收器</font>是汲取平时NoNo照顾精灵的力量凝练而成的经验接收装置，NoNo很辛苦的在照顾精灵呢，所以理所当然可以得到这些奖励。"
      },{
         "mc":"发明家肖恩",
         "word":"<font color=\'#ff0000\'>发明家肖恩</font>是所有NoNo的创造者，就是我们伟大的肖恩老师，他开发了各种赛尔性能提升装置和赛尔助手系统，是超能物质研究专家哦！"
      },{
         "mc":"nonoMC",
         "word":"<font color=\'#ff0000\'>NoNo</font>是什么呢？恩，你问了个很好的问题！NoNo是赛尔们的助手机器人，补全赛尔的种种不足，帮赛尔更好的完成所有的战斗任务、探索任务，帮助赛尔记录下宇宙探险旅程中的点点滴滴。"
      }];
      
      private var nonoMC:MovieClip;
      
      private var nonoClickMC:MovieClip;
      
      private var chipMixPic:MovieClip;
      
      private var joinMachineMC:MovieClip;
      
      private var analyzeMachineMC:MovieClip;
      
      private var getExpBtn:MovieClip;
      
      private var nonoStage:MovieClip;
      
      private var nonoGuiderMC:MovieClip;
      
      private var startDialog:MovieClip;
      
      private var superNonoDialog:MovieClip;
      
      private var viewRoomDialog:MovieClip;
      
      private var _super_mc:MovieClip;
      
      private var intervalID:Number;
      
      public var mark:MovieClip;
      
      public var hereNono:MovieClip;
      
      private var _appPane:AppModel;
      
      private var _nonoIntrolPanel:AppModel;
      
      private var targetMC:*;
      
      private var timermove:Timer;
      
      private var _superApp:AppModel;
      
      private var _nonoBookApp:AppModel;
      
      private var _nonoChipMix:AppModel;
      
      private var _isShow:Boolean = false;
      
      private var _chipApp:AppModel;
      
      private var loader:MCLoader;
      
      private var _bookApp:AppModel;
      
      public function MapProcess_107()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.b1 = false;
         ToolTipManager.add(conLevel["ccBtn"],"超能NoNo 超能体验");
         conLevel["ccBtn"].buttonMode = true;
         conLevel["ccBtn"].addEventListener(MouseEvent.CLICK,this.onCCHandler);
         depthLevel["containerMC"].mouseEnabled = false;
         depthLevel["containerMC"].mouseChildren = false;
         conLevel["markMc"].visible = false;
         this.mark = conLevel["markMc"];
         conLevel["nonoHere"].visible = false;
         this.hereNono = conLevel["nonoHere"];
         if(TasksManager.getTaskStatus(96) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(96,function(arr:Array):void
            {
               if(Boolean(arr[0]) && !arr[1])
               {
                  if(!MainManager.actorInfo.hasNono)
                  {
                     hereNono.visible = true;
                  }
               }
            });
         }
         trace("0步一点没完成");
         this.startDialog = MapLibManager.getMovieClip("StartDialog");
         this.superNonoDialog = MapLibManager.getMovieClip("SuperNonoDialog");
         this.viewRoomDialog = MapLibManager.getMovieClip("ViewRoomDialog");
         this.timer = new Timer(8000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
         this.nonoMC = depthLevel["containerMC"].nonoMC;
         this.nonoClickMC = depthLevel["nonoClick_mc"];
         this.nonoClickMC.buttonMode = true;
         this.nonoStage = depthLevel["containerMC"].nonoStage;
         this.nonoStage.buttonMode = true;
         this.chipMixPic = conLevel["chipMixMc"];
         this.joinMachineMC = conLevel["joinMachineMC"];
         this.joinMachineMC.addEventListener(MouseEvent.CLICK,this.onJoinMachineHandler);
         ToolTipManager.add(this.joinMachineMC,"超能融合机");
         this.analyzeMachineMC = conLevel["analyzeMachineMC"];
         this.analyzeMachineMC.buttonMode = true;
         this.analyzeMachineMC.addEventListener(MouseEvent.CLICK,this.onAnalyzeMachineHandler);
         ToolTipManager.add(this.analyzeMachineMC,"超能分析仪");
         this.getExpBtn = conLevel["getExpBtn"];
         this.nonoGuiderMC = topLevel["nonoGuiderMC"];
         this.nonoGuiderMC.visible = false;
         this.nonoGuiderMC.mouseEnabled = false;
         this.nonoClickMC.addEventListener(MouseEvent.CLICK,this.onNonoClickHandler);
         GetNoNo.startGet(conLevel["getNoNoBtn"]);
         this._nonoMixBookBtn = UIManager.getMovieClip("NoNoChipMix_Icon");
         this._nonoMixBookBtn["mc"].gotoAndStop(1);
         this._nonoMixBookBtn.buttonMode = true;
         this._nonoMixBookBtn["mc"].visible = false;
         this._nonoChipSo = SOManager.getNoNoChipBook_Read();
         if(!this._nonoChipSo.data.hasOwnProperty("isShow"))
         {
            this._nonoMixBookBtn["mc"].gotoAndPlay(1);
            this._nonoMixBookBtn["mc"].visible = true;
            this._nonoChipSo.data["isShow"] = true;
            SOManager.flush(this._nonoChipSo);
         }
         else
         {
            this._nonoMixBookBtn["mc"].visible = this._nonoChipSo.data["isShow"];
            if(Boolean(this._nonoMixBookBtn["mc"].visible))
            {
               this._nonoMixBookBtn["mc"].gotoAndPlay(1);
            }
         }
         conLevel.addChild(this._nonoMixBookBtn);
         ToolTipManager.add(this._nonoMixBookBtn,"芯片手册");
         this._nonoMixBookBtn.rotation = 8;
         this._nonoMixBookBtn.x = 900;
         this._nonoMixBookBtn.y = 315;
         this._nonoMixBookBtn.addEventListener(MouseEvent.CLICK,this.onChipMixHandler);
         this._nonoBookBtn = UIManager.getMovieClip("NoNoBook_Icon");
         this._nonoBookBtn.buttonMode = true;
         this._nonoBookSo = SOManager.getNoNoBook_Read();
         conLevel.addChild(this._nonoBookBtn);
         ToolTipManager.add(this._nonoBookBtn,"NoNo手册");
         this._nonoBookBtn.x = 900;
         this._nonoBookBtn.y = 255;
         this._nonoBookBtn.addEventListener(MouseEvent.CLICK,this.onNoNoBookHandler);
         this._super_mc = conLevel["superNo_btn"];
         this._nonoSuperSo = SOManager.getNoNoBook_Read();
         if(!this._nonoSuperSo.data.hasOwnProperty("isShow"))
         {
            SOManager.flush(this._nonoSuperSo);
         }
         ToolTipManager.add(this._super_mc,"超能NoNo手册");
         this._super_mc.x = 900;
         this._super_mc.y = 185;
         this._super_mc.addEventListener(MouseEvent.CLICK,this.onNoNoSuperHandler);
         if(isOpenSuperNoNo)
         {
            this.superNonoHandler();
         }
         conLevel["xinpianMc"].addEventListener(MouseEvent.MOUSE_OVER,this.onXinOverHandler);
         conLevel["xinpianMc"].addEventListener(MouseEvent.MOUSE_OUT,this.onXinOutHandler);
      }
      
      private function onXinOverHandler(e:MouseEvent) : void
      {
         this.depthLevel["containerMC"].gotoAndStop(2);
      }
      
      private function onXinOutHandler(e:MouseEvent) : void
      {
         this.depthLevel["containerMC"].gotoAndStop(1);
      }
      
      private function onCCHandler(e:MouseEvent) : void
      {
         if(!this._appPane)
         {
            this._appPane = new AppModel(ClientConfig.getAppModule("CongratulatePanel"),"正在打开祝词");
            this._appPane.setup();
         }
         this._appPane.show();
      }
      
      private function onExpBtnClick() : void
      {
         if(!MainManager.actorModel.nono)
         {
            Alarm.show("带上你的NoNo再来试试看吧！");
            return;
         }
         var userInfo:UserInfo = MainManager.actorModel.info;
         var or:DayOreCount = new DayOreCount();
         or.addEventListener(DayOreCount.countOK,this.onCount);
         if(userInfo.superNono)
         {
            or.sendToServer(2002);
         }
         else
         {
            or.sendToServer(1004);
         }
      }
      
      private function onCount(event:Event) : void
      {
         var userInfo:UserInfo = null;
         if(DayOreCount.oreCount >= 1)
         {
            Alarm.show("你已经领过哟！下周再来领吧！");
            this.getExpBtn.removeEventListener(MouseEvent.CLICK,this.onExpBtnClick);
         }
         else
         {
            userInfo = MainManager.actorModel.info;
            SocketConnection.addCmdListener(CommandID.TALK_CATE,function(event:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.TALK_CATE,arguments.callee);
               if(userInfo.superNono)
               {
                  Alarm.show("恭喜你获得了" + TextFormatUtil.getRedTxt("2000积累经验"));
               }
               else
               {
                  Alarm.show("恭喜你获得了" + TextFormatUtil.getRedTxt("2000积累经验"));
               }
            });
            if(userInfo.superNono)
            {
               SocketConnection.send(CommandID.TALK_CATE,2002);
            }
            else
            {
               SocketConnection.send(CommandID.TALK_CATE,1004);
            }
         }
      }
      
      private function onAnalyzeMachineHandler(e:MouseEvent) : void
      {
         if(!MainManager.actorModel.nono)
         {
            Alarm.show("带上你的NoNo再来试试看吧！");
            return;
         }
         var userInfo:UserInfo = MainManager.actorModel.info;
         var or:DayOreCount = new DayOreCount();
         or.addEventListener(DayOreCount.countOK,this.onCapsule);
         if(userInfo.superNono)
         {
            or.sendToServer(2101);
         }
         else
         {
            or.sendToServer(1501);
         }
      }
      
      private function onCapsule(e:Event) : void
      {
         var userInfo:UserInfo = null;
         userInfo = MainManager.actorModel.info;
         if(DayOreCount.oreCount >= 1)
         {
            Alarm.show("本月你已经领过哟！下个月再来领吧！");
            this.analyzeMachineMC.removeEventListener(MouseEvent.CLICK,this.onAnalyzeMachineHandler);
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.TALK_CATE,function(event:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.TALK_CATE,arguments.callee);
               if(userInfo.superNono)
               {
                  ItemInBagAlert.show(300007,"你已获得1个超能胶囊");
               }
               else
               {
                  ItemInBagAlert.show(300003,"你已获得1个高级胶囊");
               }
            });
            if(userInfo.superNono)
            {
               SocketConnection.send(CommandID.TALK_CATE,2101);
            }
            else
            {
               SocketConnection.send(CommandID.TALK_CATE,1501);
            }
         }
      }
      
      private function onTimer(event:TimerEvent = null) : void
      {
         if(this.timerIndex == this.wordArr.length)
         {
            this.timerIndex = 0;
         }
         var box:DialogBox = new DialogBox();
         box.show(this.wordArr[this.timerIndex],-10,-85,this.nonoMC);
         ++this.timerIndex;
      }
      
      private function onJoinMachineHandler(e:MouseEvent) : void
      {
         this.superNonoHandler();
      }
      
      private function open() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_OPEN_SUPER,this.onSuperSuccessHandler);
         SocketConnection.send(CommandID.NONO_OPEN_SUPER);
      }
      
      private function onSuperSuccessHandler(e:SocketEvent) : void
      {
         var ninfo:NonoInfo = null;
         if(Boolean(MainManager.actorModel.nono))
         {
            ninfo = MainManager.actorModel.nono.info;
            ninfo.superNono = true;
            MainManager.actorModel.hideNono();
            MainManager.actorModel.showNono(ninfo,MainManager.actorInfo.actionType);
         }
         var mclloader:MCLoader = new MCLoader("resource/bounsMovie/superNonoMovie.swf",LevelManager.appLevel,1,"正在打开进化过程");
         mclloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadMovie);
         mclloader.doLoad();
         MainManager.actorInfo.superNono = true;
      }
      
      private function onLoadMovie(event:MCLoadEvent) : void
      {
         var content:MovieClip = null;
         content = event.getContent() as MovieClip;
         MainManager.getStage().addChild(content);
         content.addEventListener("NONO_OVER",function(event:Event):void
         {
            DisplayUtil.removeForParent(content);
            NpcTipDialog.show("(*^__^*) 锵锵，你的" + MainManager.actorInfo.nonoNick + "已经成为超能NoNo了。看看它发着蓝光的美丽姿态，看看它精明能干的样子，它将成为你永远离不开的好帮手哦！",null,NpcTipDialog.NONO);
            if(!NonoManager.isBeckon)
            {
               NonoManager.isBeckon = true;
               SocketConnection.send(CommandID.NONO_FOLLOW_OR_HOOM,1);
               NonoManager.info.superNono = true;
               MainManager.actorModel.hideNono();
               MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
            }
         });
      }
      
      private function superNonoHandler() : void
      {
         var next:Function;
         var r:VipSession = null;
         r = new VipSession();
         if(MainManager.actorInfo.superNono)
         {
            NpcTipDialog.showAnswer("你已经拥有超能NoNo，是否需要续费？",function():void
            {
               r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
               {
               });
               r.getSession();
            },null,NpcTipDialog.NONO);
            return;
         }
         if(!MainManager.actorInfo.vip)
         {
            next = function():void
            {
               NpcTipDialog.show("完成相关的开通手续以后，点击<font color=\'#ff0000\'>超能融合机</font>就能完成超能NoNo的变身了。",function():void
               {
                  r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
                  {
                  });
                  r.getSession();
               },NpcTipDialog.NONO);
            };
            NpcTipDialog.show("我就知道你一定会做出这个明智的选择，看看我们肖恩老师，有了我的帮助多么轻松啊，那么让我们开始吧！",next,NpcTipDialog.NONO);
            return;
         }
         if(Boolean(MainManager.actorInfo.vip) && !MainManager.actorInfo.superNono)
         {
            this.open();
         }
      }
      
      private function onBtnClickHandler(e:MouseEvent) : void
      {
         if(this.targetMC)
         {
            this.targetMC.filters = null;
         }
         switch(e.currentTarget.name)
         {
            case "closeBtn":
               DisplayUtil.removeForParent((e.currentTarget as SimpleButton).parent);
               break;
            case "viewRoomBtn":
               this.initViewRoomDialog();
               break;
            case "viewNonoBtn":
               this.initSuperNonoDialog();
               break;
            case "underNonoBtn":
               DisplayUtil.removeForParent((e.currentTarget as SimpleButton).parent);
               if(!this._nonoIntrolPanel)
               {
                  this._nonoIntrolPanel = new AppModel(ClientConfig.getAppModule("IntrolNonoPanel"),"正在打开超能nono介绍面板");
                  this._nonoIntrolPanel.setup();
               }
               this._nonoIntrolPanel.show();
               break;
            case "changeToNonoBtn":
               DisplayUtil.removeForParent((e.currentTarget as SimpleButton).parent);
               this.superNonoHandler();
               break;
            case "claimNonoBtn":
               this.onNonoGuiderHandler(conLevel["getNoNoBtn"],conLevel);
               break;
            case "nonoStageBtn":
               this.onNonoGuiderHandler(this.nonoStage,depthLevel["containerMC"]);
               break;
            case "chipMixPicBtn":
               this.onNonoGuiderHandler(this.chipMixPic,conLevel);
               break;
            case "analyzeMachineBtn":
               this.onNonoGuiderHandler(this.analyzeMachineMC,conLevel);
               break;
            case "NonoBtn":
               this.onNonoGuiderHandler(this.nonoMC,depthLevel["containerMC"]);
               break;
            case "joinMachineBtn":
               this.onNonoGuiderHandler(this.joinMachineMC,conLevel);
               break;
            case "getExpBtn":
               this.onNonoGuiderHandler(this.getExpBtn,conLevel);
         }
      }
      
      private function initStartDialog() : void
      {
         var btn:SimpleButton = null;
         LevelManager.appLevel.addChild(this.startDialog);
         DisplayUtil.align(this.startDialog,null,AlignType.MIDDLE_CENTER);
         for(var i:uint = 0; i < this.startDialog.numChildren; i++)
         {
            if(this.startDialog.getChildAt(i) is SimpleButton)
            {
               btn = this.startDialog.getChildAt(i) as SimpleButton;
               btn.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
            }
         }
      }
      
      private function initSuperNonoDialog() : void
      {
         var btn:SimpleButton = null;
         if(Boolean(this.startDialog))
         {
            DisplayUtil.removeForParent(this.startDialog);
         }
         LevelManager.appLevel.addChild(this.superNonoDialog);
         DisplayUtil.align(this.superNonoDialog,null,AlignType.MIDDLE_CENTER);
         for(var i:uint = 0; i < this.superNonoDialog.numChildren; i++)
         {
            if(this.superNonoDialog.getChildAt(i) is SimpleButton)
            {
               btn = this.superNonoDialog.getChildAt(i) as SimpleButton;
               btn.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
            }
         }
      }
      
      private function initViewRoomDialog() : void
      {
         var btn:SimpleButton = null;
         if(Boolean(this.startDialog))
         {
            DisplayUtil.removeForParent(this.startDialog);
         }
         LevelManager.appLevel.addChild(this.viewRoomDialog);
         DisplayUtil.align(this.viewRoomDialog,null,AlignType.MIDDLE_CENTER);
         for(var i:uint = 0; i < this.viewRoomDialog.numChildren; i++)
         {
            if(this.viewRoomDialog.getChildAt(i) is SimpleButton)
            {
               btn = this.viewRoomDialog.getChildAt(i) as SimpleButton;
               btn.addEventListener(MouseEvent.CLICK,this.onBtnClickHandler);
            }
         }
      }
      
      private function onNonoClickHandler(e:MouseEvent) : void
      {
         NpcTipDialog.show("嗨，" + TextFormatUtil.getRedTxt(MainManager.actorInfo.nick) + "你好，肖恩老师可是个大忙人哦，有什么问题就问我吧。",this.initStartDialog,NpcTipDialog.NONO);
      }
      
      private function onNonoGuiderHandler(mc:*, mcparent:*) : void
      {
         this.viewRoomDialog.visible = false;
         this.nonoGuiderMC.visible = true;
         this.mcMove(this.nonoGuiderMC,mc,mcparent);
      }
      
      private function mcMove(mc:MovieClip, mc1:*, mc1parent:*) : void
      {
         this.targetMC = mc1;
         var p1:Point = topLevel.localToGlobal(new Point(mc.x,mc.y));
         var p2:Point = mc1parent.localToGlobal(new Point(mc1.x,mc1.y));
         if(p2.x - p1.x > 0)
         {
            mc.gotoAndStop(2);
         }
         else
         {
            mc.gotoAndStop(1);
         }
         var xlen:Number = Math.ceil(p2.x) - Math.ceil(p1.x) + mc.width;
         var ylen:Number = Math.ceil(p2.y) - Math.ceil(p1.y) + mc.height;
         var radian:Number = Math.atan2(ylen,xlen);
         var angle:Number = Math.ceil(radian * 180 / Math.PI);
         this.timermove = new Timer(100);
         this.timermove.addEventListener(TimerEvent.TIMER,this.nonoMove(mc,mc1,p2.x,p2.y,radian));
         this.timermove.start();
      }
      
      private function nonoMove(mc:MovieClip, mc1:*, xx:Number, yy:Number, radian:Number) : Function
      {
         var func:Function = function(e:TimerEvent):void
         {
            var b:Boolean;
            var glowF:GlowFilter = null;
            var i:uint = 0;
            var newP:Point = topLevel.localToGlobal(new Point(mc.x,mc.y));
            var newxlen:Number = Math.abs(xx - newP.x);
            var newylen:Number = Math.abs(yy - newP.y);
            mc.x += Math.cos(radian) * 20;
            mc.y += Math.sin(radian) * 20;
            b = false;
            if(newxlen < mc1.width && newylen < mc1.height || newxlen < 100 && newylen < 100)
            {
               timermove.stop();
               timermove.removeEventListener(TimerEvent.TIMER,nonoMove(mc,mc1,xx,yy,radian));
               timermove = null;
               glowF = new GlowFilter();
               glowF.blurX = 100;
               glowF.blurY = 100;
               glowF.strength = 5;
               glowF.color = 16777215;
               targetMC.filters = [glowF];
               for(i = 0; i < introlWordArr.length; i++)
               {
                  if(introlWordArr[i].mc == targetMC.name)
                  {
                     intervalID = setTimeout(function():void
                     {
                        NpcTipDialog.show(introlWordArr[i].word,showDialog,NpcTipDialog.NONO);
                        clearTimeout(intervalID);
                     },1000);
                     break;
                  }
               }
            }
         };
         return func;
      }
      
      private function showDialog() : void
      {
         this.viewRoomDialog.visible = true;
         this.nonoGuiderMC.visible = false;
      }
      
      private function showCodePanel() : void
      {
         if(!this._panelApp)
         {
            this._panelApp = new AppModel(ClientConfig.getAppModule("MonsterCapsulePanel"),"正在进入");
            this._panelApp.setup();
            this._panelApp.sharedEvents.addEventListener(Event.CLOSE,this.onClosePanelHandler);
         }
         this._panelApp.show();
         this.b1 = true;
      }
      
      private function onClosePanelHandler(e:Event) : void
      {
         this.b1 = false;
      }
      
      public function onTempHandler() : void
      {
         conLevel["aniMc"].gotoAndPlay(2);
         conLevel["aniMc"].addEventListener(Event.ENTER_FRAME,this.onAiHandler);
      }
      
      private function onAiHandler(e:Event) : void
      {
         if(conLevel["aniMc"].currentFrame == conLevel["aniMc"].totalFrames)
         {
            conLevel["aniMc"].removeEventListener(Event.ENTER_FRAME,this.onAiHandler);
            TasksManager.setProStatus(29,0,true);
            this._tipMc = MapLibManager.getMovieClip("ShawnTip_MC");
            this._tipMc["txt"].text = "A001";
            this._tipMc["nameTxt"].text = MainManager.actorInfo.nick;
            this._tipMc["msgTxt"].text = "\n    一个精灵同时能够记住几个技能？";
            this._tipMc["closeBtn"].addEventListener(MouseEvent.CLICK,this.onTipClickHandler);
            LevelManager.appLevel.addChild(this._tipMc);
            DisplayUtil.align(this._tipMc,null,AlignType.MIDDLE_CENTER);
         }
      }
      
      private function onTipClickHandler(e:MouseEvent) : void
      {
         this._tipMc["closeBtn"].removeEventListener(MouseEvent.CLICK,this.onTipClickHandler);
         DisplayUtil.removeForParent(this._tipMc);
         this._tipMc = null;
      }
      
      private function onNoNoBookHandler(e:MouseEvent) : void
      {
         if(Boolean(this._nonoSuperSo.data["isShow"]))
         {
            this._nonoSuperSo.data["isShow"] = false;
            SOManager.flush(this._nonoSuperSo);
            this._super_mc["mc"].gotoAndStop(1);
            this._super_mc["mc"].visible = false;
         }
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         if(!this._nonoBookApp)
         {
            this._nonoBookApp = new AppModel(ClientConfig.getBookModule("NoNoBook"),"正在打开NoNo手册");
            this._nonoBookApp.setup();
            this._nonoBookApp.sharedEvents.addEventListener(Event.CLOSE,this.onNoNoBookCloseHandler);
            this._nonoBookApp.sharedEvents.addEventListener(Event.OPEN,this.onOpenHandler);
            this._nonoBookApp.sharedEvents.addEventListener("supernonooper",this.onSuperNoOper);
         }
         this._nonoBookApp.show();
      }
      
      private function onNoNoSuperHandler(e:MouseEvent) : void
      {
         if(Boolean(this._nonoBookSo.data["isShow"]))
         {
            this._nonoBookSo.data["isShow"] = false;
            SOManager.flush(this._nonoBookSo);
            this._nonoBookBtn["mc"].gotoAndStop(1);
            this._nonoBookBtn["mc"].visible = false;
         }
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(Boolean(this._superApp))
         {
         }
         if(!this._superApp)
         {
            this._superApp = new AppModel(ClientConfig.getBookModule("NoNoJieShaoBook"),"正在打开NoNo手册");
            this._superApp.setup();
            this._superApp.sharedEvents.addEventListener(Event.CLOSE,this.onNoNoJieShaoBookCloseHandler);
            this._superApp.sharedEvents.addEventListener(Event.OPEN,this.onOpenHandler);
            this._superApp.sharedEvents.addEventListener("nonobookchange",this.onOpenHandler1);
            this._superApp.sharedEvents.addEventListener("changewudou",this.changewudouHandler);
         }
         this._superApp.show();
      }
      
      private function changewudouHandler(e:Event) : void
      {
         this._superApp.sharedEvents.removeEventListener("changewudou",this.changewudouHandler);
         this.onBookHandler();
         this._superApp.destroy();
      }
      
      private function onNoNoJieShaoBookCloseHandler(e:Event) : void
      {
         if(!this._superApp)
         {
            return;
         }
         this._superApp.sharedEvents.removeEventListener(Event.OPEN,this.onOpenHandler);
         this._superApp.sharedEvents.removeEventListener(Event.CLOSE,this.onNoNoJieShaoBookCloseHandler);
         this._superApp.sharedEvents.removeEventListener("nonobookchange",this.onOpenHandler1);
         this._superApp.destroy();
         this._superApp = null;
      }
      
      private function onNoNoBookCloseHandler(e:Event = null) : void
      {
         if(!this._nonoBookApp)
         {
            return;
         }
         this._nonoBookApp.sharedEvents.removeEventListener(Event.OPEN,this.onOpenHandler);
         this._nonoBookApp.sharedEvents.removeEventListener(Event.CLOSE,this.onNoNoBookCloseHandler);
         this._nonoBookApp.destroy();
         this._nonoBookApp = null;
      }
      
      private function onSuperNoOper(e:Event) : void
      {
         this.onCloseMixHandler(null);
         this.onNoNoBookCloseHandler(null);
         this.onNoNoSuperHandler(null);
      }
      
      private function onOpenHandler1(e:Event) : void
      {
         this.onCloseMixHandler(null);
         this.onNoNoJieShaoBookCloseHandler(null);
         this.onNoNoBookHandler(null);
      }
      
      private function onOpenHandler(e:Event) : void
      {
         this.onNoNoJieShaoBookCloseHandler(null);
         this.onNoNoBookCloseHandler(null);
         this.onChipMixHandler(null);
      }
      
      private function onChipMixHandler(e:MouseEvent) : void
      {
         if(Boolean(this._nonoChipSo.data["isShow"]))
         {
            this._nonoChipSo.data["isShow"] = false;
            SOManager.flush(this._nonoChipSo);
            this._nonoMixBookBtn["mc"].gotoAndStop(1);
            this._nonoMixBookBtn["mc"].visible = false;
         }
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         if(!this._nonoChipMix)
         {
            this._nonoChipMix = new AppModel(ClientConfig.getBookModule("NoNoChipMicBook"),"正在打开芯片合成书");
            this._nonoChipMix.setup();
            this._nonoChipMix.sharedEvents.addEventListener(Event.CLOSE,this.onCloseMixHandler);
         }
         this._nonoChipMix.show();
      }
      
      private function onCloseMixHandler(e:Event) : void
      {
         if(!this._nonoChipMix)
         {
            return;
         }
         this._nonoChipMix.sharedEvents.removeEventListener(Event.CLOSE,this.onCloseMixHandler);
         this._nonoChipMix.destroy();
         this._nonoChipMix = null;
      }
      
      override public function destroy() : void
      {
         conLevel["xinpianMc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onXinOverHandler);
         conLevel["xinpianMc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onXinOutHandler);
         ToolTipManager.remove(conLevel["ccBtn"]);
         conLevel["ccBtn"].removeEventListener(MouseEvent.CLICK,this.onCCHandler);
         if(Boolean(this._appPane))
         {
            this._appPane.destroy();
            this._appPane = null;
         }
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         if(Boolean(this._superApp))
         {
            this._superApp.sharedEvents.removeEventListener("changewudou",this.changewudouHandler);
            this._superApp.destroy();
         }
         if(Boolean(this._bookApp))
         {
            this._bookApp.destroy();
         }
         isOpenSuperNoNo = false;
         this._super_mc.x = 2000;
         this._super_mc = null;
         if(Boolean(this.questionPanel))
         {
            this.questionPanel.destroy();
            this.questionPanel = null;
         }
         if(Boolean(this._panelApp))
         {
            this._panelApp.sharedEvents.removeEventListener(Event.CLOSE,this.onClosePanelHandler);
            this._panelApp.destroy();
            this._panelApp = null;
         }
         if(Boolean(this._tipMc))
         {
            this.onTipClickHandler(null);
         }
         GetNoNo.destroy();
         ToolTipManager.remove(this._nonoBookBtn);
         ToolTipManager.remove(this._nonoMixBookBtn);
         this._nonoBookBtn.removeEventListener(MouseEvent.CLICK,this.onNoNoBookHandler);
         DisplayUtil.removeForParent(this._nonoBookBtn);
         this._nonoMixBookBtn.removeEventListener(MouseEvent.CLICK,this.onChipMixHandler);
         DisplayUtil.removeForParent(this._nonoMixBookBtn);
         if(Boolean(this._nonoBookApp))
         {
            this.onNoNoBookCloseHandler(null);
         }
         if(Boolean(this._nonoChipMix))
         {
            this.onCloseMixHandler(null);
         }
         if(Boolean(this._chipApp))
         {
            this._chipApp.sharedEvents.removeEventListener(Event.CLOSE,this.onChipCloseHandler);
            this._chipApp.destroy();
            this._chipApp = null;
         }
         if(Boolean(this._xinpianApp))
         {
            this._xinpianApp.destroy();
            this._xinpianApp = null;
         }
      }
      
      public function chipMixHandler() : void
      {
         if(!this._isShow)
         {
            ExchangeOreModel.getData(this.onGetComHandler,"你目前还没有合成芯片的材料，快打开右下角的<font color=\'#ff0000\'>芯片手册</font>看看吧，可能对你会有所帮助哦！");
         }
      }
      
      private function onGetComHandler(data:Object) : void
      {
         if(Boolean(data))
         {
            if(!this._chipApp)
            {
               this._chipApp = new AppModel(ClientConfig.getAppModule("ChipMixturePanel"),"正在打开芯片制造机");
               this._chipApp.setup();
               this._chipApp.sharedEvents.addEventListener(Event.CLOSE,this.onChipCloseHandler);
            }
            this._chipApp.init(data);
            this._isShow = true;
         }
      }
      
      private function onChipCloseHandler(e:Event) : void
      {
         this._chipApp.hide();
         this._isShow = false;
      }
      
      public function onGetExpHit() : void
      {
         this.onExpBtnClick();
      }
      
      private function onHelpExp(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.NONO_HELP_EXP,this.onHelpExp);
         NpcTipDialog.show("看来精灵助手" + TextFormatUtil.getRedTxt(MainManager.actorInfo.nonoNick) + "把你的精灵们都照顾得很好呢，去" + TextFormatUtil.getRedTxt("经验分配器") + "查收奖励吧。记得下周再来这里，要好好待它哦！",function():void
         {
            Alarm.show("你获得了" + TextFormatUtil.getRedTxt("5000") + "积累经验。");
         },NpcTipDialog.NONO);
      }
      
      private function showQuestion() : void
      {
         this.loadApp();
      }
      
      private function loadApp() : void
      {
         if(!this.questionPanel)
         {
            this.questionPanel = ModuleManager.getModule(ClientConfig.getTaskModule("ShawnQuestion"),"正在载入问答题");
            this.questionPanel.setup();
         }
         this.questionPanel.show();
      }
      
      public function onXinpianHit() : void
      {
         if(Boolean(MainManager.actorModel.nono))
         {
            if(Boolean(MainManager.actorInfo.vip))
            {
               NpcTipDialog.show("锵锵！本期礼物揭晓啦，亲爱的小赛尔，你的超能NoNo是不是特别乖啊？你的超能NoNo是不是特别可爱啊？你的超能NoNo是不是特别聪明啊？收下肖恩老师的新发明吧！",function():void
               {
                  if(_xinpianApp == null)
                  {
                     _xinpianApp = ModuleManager.getModule(ClientConfig.getAppModule("XinPianDocPanel"),"正在加载芯片说明...");
                     _xinpianApp.setup();
                  }
                  _xinpianApp.show();
               },NpcTipDialog.NONO);
            }
            else
            {
               NpcTipDialog.show("可惜哦，只有像我一样聪明可爱的" + TextFormatUtil.getRedTxt("超能NoNo") + "才可以领取这些肖恩老师的小礼物呢！",null,NpcTipDialog.NONO);
            }
         }
         else
         {
            NpcTipDialog.show("带上你的NoNo再来吧，惊喜每日有，今日特别多哦！有空常来看看！",null,NpcTipDialog.NONO);
         }
      }
      
      public function onOreGatherClickHandler() : void
      {
         if(Boolean(MainManager.actorInfo.superNono) && Boolean(MainManager.actorModel.nono))
         {
            SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
            SocketConnection.send(CommandID.JOIN_GAME,1);
         }
         else
         {
            Alarm.show("带上" + TextFormatUtil.getRedTxt("超能NoNo") + "才能开始精灵体能的测试哦！");
         }
      }
      
      private function onJoinGame(e:SocketEvent) : void
      {
         MapManager.destroy();
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGame);
         this.loader = new MCLoader("resource/Games/FirBoatGetRockGame.swf",LevelManager.topLevel,1,"正在加载游戏");
         this.loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         this.loader.doLoad();
      }
      
      private function onLoadDLL(event:MCLoadEvent) : void
      {
         this.loader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadDLL);
         LevelManager.topLevel.addChild(event.getContent());
         event.getContent().addEventListener("gamewin",this.onGameOver);
         event.getContent().addEventListener("gamelost",this.onGameLost);
      }
      
      private function onBookHandler() : void
      {
         if(this._bookApp == null)
         {
            this._bookApp = new AppModel(ClientConfig.getBookModule("DarkProtalBookPanel"),"正在打开");
            this._bookApp.setup();
         }
         this._bookApp.show();
      }
      
      private function onGameLost(e:Event) : void
      {
         MapManager.refMap();
         SocketConnection.send(CommandID.GAME_OVER,0,0);
         NpcTipDialog.show("超能晶体是非常稀有的矿产资源，不是每个人都可以轻易采集得到哦，认真找找规律看看。",null,NpcTipDialog.DOCTOR);
      }
      
      private function onGameOver(e:Event) : void
      {
         var sp:* = e.target as Sprite;
         var bili:int = int(sp.getLife() / 10 * 100);
         var score:int = int(800 * bili * 0.01);
         MapManager.refMap();
         SocketConnection.send(CommandID.GAME_OVER,bili,bili);
      }
   }
}

