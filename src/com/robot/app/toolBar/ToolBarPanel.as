package com.robot.app.toolBar
{
   import com.robot.app.action.ActorActionManager;
   import com.robot.app.bag.BagController;
   import com.robot.app.chat.ChatPanel;
   import com.robot.app.emotion.EmotionController;
   import com.robot.app.im.AddFriendMsgController;
   import com.robot.app.im.IMController;
   import com.robot.app.petbag.PetBagController;
   import com.robot.app.protectSys.ProtectSystem;
   import com.robot.app.quickWord.QuickWordController;
   import com.robot.app.specialIcon.SpecialIconController;
   import com.robot.app.worldMap.WorldMapController;
   import com.robot.core.CommandID;
   import com.robot.core.SoundManager;
   import com.robot.core.aimat.AimatGridPanel;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.InformInfo;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.info.team.TeamInformInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import com.robot.app.team.TeamController;
   import com.robot.core.manager.UserManager;
   import com.robot.core.config.xml.ItemTipXMLInfo;
   public class ToolBarPanel extends Sprite
   {
      private var _chatPanel:ChatPanel;

      public var OLDY:Number;

      private var _mainUI:Sprite;

      private var _inputTxt:TextField;

      private var _inputBtn:SimpleButton;

      private var _mapBtn:SimpleButton;

      private var _petBtn:SimpleButton;

      private var _teamBtn:MovieClip;

      private var _showChatBtn:SimpleButton;

      private var _nonoBtn:MovieClip;

      private var _nonoIcon:MovieClip;

      private var _quickWordBtn:SimpleButton;

      private var _emotionBtn:SimpleButton;

      private var _danceBtn:SimpleButton;

      private var _aimatBtn:SimpleButton;

      private var _imBtn:MovieClip;

      private var _bagBtn:SimpleButton;

      private var _addFriendBtn:MovieClip;

      private var _addTeamBtn:MovieClip;

      private var _homeBtn:SimpleButton;

      private var spt_btn:SimpleButton;

      private var _soundController_mc:MovieClip;

      private var _user_mc:MovieClip;

      private var date:Date;

      private var _isSend:Boolean = true;

      public function ToolBarPanel()
      {
         super();
         this._mainUI = UIManager.getSprite("ToolBarMC");
         this._inputTxt = this._mainUI["inputTxt"];
         this._inputBtn = this._mainUI["inputBtn"];
         this._mapBtn = this._mainUI["mapBtn"];
         this._quickWordBtn = this._mainUI["quickWordBtn"];
         this._emotionBtn = this._mainUI["emotionBtn"];
         this._danceBtn = this._mainUI["danceBtn"];
         this._aimatBtn = this._mainUI["aimatBtn"];
         this._imBtn = this._mainUI["imBtn"];
         this._imBtn.gotoAndStop(1);
         this._imBtn.buttonMode = true;
         this._bagBtn = this._mainUI["bagBtn"];
         this._petBtn = this._mainUI["petBtn"];
         this._showChatBtn = this._mainUI["showChatBtn"];
         this._homeBtn = this._mainUI["homeBtn"];
         this._teamBtn = this._mainUI["teamBtn"];
         this._teamBtn.gotoAndStop(1);
         this._nonoBtn = TaskIconManager.getIcon("nonoBtn") as MovieClip;
         this._nonoBtn["nonoNewMC"].mouseEnabled = false;
         this._nonoBtn["nonoNewMC"].mouseChildren = false;
         this._nonoIcon = this._nonoBtn["nonoIcon"];
         this._nonoIcon.buttonMode = true;
         this._nonoIcon.gotoAndStop(1);
         this._nonoIcon["tooltip_mc"].gotoAndStop(1);
         this._nonoIcon["tooltip_mc"].visible = false;
         this._nonoIcon.addEventListener(MouseEvent.ROLL_OVER, this.onRollOverHandler);
         this._nonoIcon.addEventListener(MouseEvent.ROLL_OUT, this.onRollOutHandler);
         this._nonoBtn.x = 862;
         this._nonoBtn.y = -80;
         var nono:uint = uint(SOManager.getUserSO("superNono").data["version"]);
         if (nono >= ClientConfig.superNoNo)
         {
            DisplayUtil.removeForParent(this._nonoBtn["nonoNewMC"]);
         }
         this._mainUI.addChild(this._nonoBtn);
         this._soundController_mc = this._mainUI["soundController_mc"];
         this._soundController_mc.useHandCursor = true;
         this._soundController_mc.buttonMode = true;
         this._soundController_mc.gotoAndStop(1);
         // this._soundController_mc["mc2"].visible = false;
         // this._soundController_mc["mc1"].visible = true;

         this._user_mc = this._mainUI["userMc"];
         this._user_mc.useHandCursor = true;
         this._user_mc.buttonMode = true;
         this._user_mc.gotoAndStop(1);

         ProtectSystem.start(this._mainUI["BatteryMC"]);
         addChild(this._mainUI);
         this._inputTxt.restrict = "^妈";
         this._inputTxt.maxChars = 30;
         this._mainUI.mouseEnabled = false;
         mouseEnabled = false;
         this._addFriendBtn = this._mainUI["addFriednBtn"];
         this._addFriendBtn.gotoAndStop(1);
         this._addFriendBtn.visible = false;
         this._addTeamBtn = this._mainUI["addTeamBtn"];
         this._addTeamBtn.gotoAndStop(1);
         this._addTeamBtn.visible = false;
         this._chatPanel = new ChatPanel();
         QuickWordController.setup();
      }

      public function closePetBag(b1:Boolean):void
      {
         this._petBtn.mouseEnabled = b1;
      }

      private function getTime():void
      {
         if (Boolean(this.date))
         {
            this.showTip(this.date);
            return;
         }
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME, this.onTimeHandler);
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }

      private function onTimeHandler(e:SocketEvent):void
      {
         SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME, this.onTimeHandler);
         var by:SystemTimeInfo = e.data as SystemTimeInfo;
         this.date = by.date;
         this.showTip(this.date);
      }

      private function showTip(d:Date):void
      {
         var dates:int = 0;
         var tipStr:String = "";
         if (MainManager.actorInfo.superNono)
         {
            if (Boolean(MainManager.actorInfo.autoCharge))
            {
               tipStr = "超能等级<font size=\'14\' color=\'#ffff00\'><b>" + MainManager.actorInfo.vipLevel + "</b></font>级\n超级能量满满！";
               this._nonoIcon.gotoAndStop(2);
            }
            else
            {
               dates = (MainManager.actorInfo.vipEndTime - d.time / 1000) / 86400;
               if (dates < 0)
               {
                  dates = 0;
               }
               if (MainManager.actorInfo.vipEndTime < d.time / 1000)
               {
                  tipStr = "超能等级<font size=\'14\' color=\'#ffff00\'><b>" + MainManager.actorInfo.vipLevel + "</b></font>级\n超级能量剩余<font color=\'#ffff00\'>" + 0 + "</font>天,快点充能吧！";
                  this._nonoIcon.gotoAndStop(3);
               }
               if (dates > 5)
               {
                  tipStr = "超能等级<font size=\'14\' color=\'#ffff00\'><b>" + MainManager.actorInfo.vipLevel + "</b></font>级\n超级能量剩余<font color=\'#ffff00\'>" + dates + "</font>天";
                  this._nonoIcon.gotoAndStop(2);
               }
               else if (dates <= 5 && dates >= 0)
               {
                  tipStr = "超能等级<font size=\'14\' color=\'#ffff00\'><b>" + MainManager.actorInfo.vipLevel + "</b></font>级\n超级能量剩余<font color=\'#ffff00\'>" + dates + "</font>天,快点充能吧！";
                  this._nonoIcon.gotoAndStop(3);
               }
            }
         }
         else if (MainManager.actorInfo.vip == 2)
         {
            tipStr = "曾经超能等级<font size=\'14\' color=\'#ffff00\'><b>" + MainManager.actorInfo.vipLevel + "</b></font>级\nNoNo已经失去超能力,快点充能吧！";
            this._nonoIcon.gotoAndStop(3);
         }
         else if (MainManager.actorInfo.vip == 0)
         {
            tipStr = "超能NoNo拥有无与伦比的超能力，快为你的NoNo充能吧！";
            this._nonoIcon.gotoAndStop(1);
         }
         else
         {
            tipStr = "快去<font color=\'#ffff00\'>发明室</font>为你的NoNo进行超能融合，开始超能之旅";
            this._nonoIcon.gotoAndStop(2);
         }
         (this._nonoIcon["tooltip_mc"]["mc"]["txt"] as TextField).htmlText = tipStr;
      }

      private function onRollOverHandler(e:MouseEvent):void
      {
         this._nonoIcon["tooltip_mc"].visible = true;
         this._nonoIcon["tooltip_mc"].gotoAndPlay(2);
         this.getTime();
      }

      private function onRollOutHandler(e:MouseEvent):void
      {
         SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME, this.onTimeHandler);
         this._nonoIcon["tooltip_mc"].visible = false;
         (this._nonoIcon["tooltip_mc"]["mc"]["txt"] as TextField).htmlText = "";
         this._nonoIcon["tooltip_mc"].gotoAndStop(1);
         this._nonoIcon.gotoAndStop(1);
      }

      private function onMusicMcClickHandler(event:MouseEvent):void
      {
         if (SoundManager.getIsPlay == true)
         {
            // this._soundController_mc["mc2"].visible = true;
            // this._soundController_mc["mc1"].visible = false;
            this._soundController_mc.gotoAndStop(2);
            ToolTipManager.remove(this._soundController_mc);
            ToolTipManager.add(this._soundController_mc, "声音");
            SoundManager.setIsPlay = false;
            SoundManager.stopSound();
         }
         else
         {
            // this._soundController_mc["mc2"].visible = false;
            // this._soundController_mc["mc1"].visible = true;
            this._soundController_mc.gotoAndStop(1);
            ToolTipManager.remove(this._soundController_mc);
            ToolTipManager.add(this._soundController_mc, "静音");
            SoundManager.setIsPlay = true;
            SoundManager.playSound();
         }
      }

      private function onUserMcClickHandler(event:MouseEvent):void
      {
         MapManager.currentMap.switchOtherUserVisible();
         ToolTipManager.remove(this._user_mc);
         ToolTipManager.add(this._user_mc,UserManager._hideOtherUserModelFlag ?  "显示其他玩家" : "屏蔽其他玩家");
         this._user_mc.gotoAndStop(UserManager._hideOtherUserModelFlag ? 2 : 1);
      }

      public function show():void
      {
         this.addEvent();
         DisplayUtil.align(this, null, AlignType.BOTTOM_CENTER);
         this.x = 11;
         LevelManager.toolsLevel.addChild(this);
         this.OLDY = this.y;
      }

      public function hide():void
      {
         this.removeEvent();
         DisplayUtil.removeForParent(this, false);
      }

      public function addEvent():void
      {
         this._inputTxt.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyBoardInput);
         this._inputBtn.addEventListener(MouseEvent.CLICK, this.onInput);
         this._mapBtn.addEventListener(MouseEvent.CLICK, this.onMap);
         this._quickWordBtn.addEventListener(MouseEvent.CLICK, this.onQuickWord);
         this._emotionBtn.addEventListener(MouseEvent.CLICK, this.onEmotion);
         this._danceBtn.addEventListener(MouseEvent.CLICK, this.onDance);
         this._aimatBtn.addEventListener(MouseEvent.CLICK, this.onAimat);
         this._imBtn.addEventListener(MouseEvent.CLICK, this.onIm);
         this._bagBtn.addEventListener(MouseEvent.CLICK, this.onBag);
         this._petBtn.addEventListener(MouseEvent.CLICK, this.onShowPet);
         this._showChatBtn.addEventListener(MouseEvent.CLICK, this.onShowChat);
         this._chatPanel.addEventListener(Event.CLOSE, this.onChatClose);
         this._homeBtn.addEventListener(MouseEvent.CLICK, this.onGoHome);
         this._teamBtn.addEventListener(MouseEvent.CLICK, this.onTeam);
         this._nonoBtn.addEventListener(MouseEvent.CLICK, this.onNonoList);
         this._soundController_mc.addEventListener(MouseEvent.CLICK, this.onMusicMcClickHandler);
         this._user_mc.addEventListener(MouseEvent.CLICK, this.onUserMcClickHandler);
         MessageManager.addEventListener(RobotEvent.ADD_FRIEND_MSG, this.onAddFriend);
         MessageManager.addEventListener(RobotEvent.ADD_TEAM_MSG, this.onInviteJoinTeam);
         ToolTipManager.add(this._soundController_mc, "声音");
         ToolTipManager.add(this._user_mc, "屏蔽其他玩家");
         ToolTipManager.add(this._mapBtn, "地图");
         ToolTipManager.add(this._quickWordBtn, "快捷语言");
         ToolTipManager.add(this._emotionBtn, "表情");
         ToolTipManager.add(this._danceBtn, "动作");
         ToolTipManager.add(this._aimatBtn, "瞄准");
         ToolTipManager.add(this._bagBtn, "储存箱");
         ToolTipManager.add(this._imBtn, "好友");
         ToolTipManager.add(this._homeBtn, "基地");
         ToolTipManager.add(this._petBtn, "精灵");
         ToolTipManager.add(this._teamBtn, "战队");
      }

      public function bubble(nick:String):void
      {
         var box:DialogBox = null;
         if (Boolean(this._teamBtn))
         {
            box = new DialogBox();
            box.show("战队成员" + nick + "为战队建设做出了贡献,获得奖励并被表彰！", this._teamBtn.x + 25, 5, this);
         }
      }

      public function removeEvent():void
      {
         this._inputBtn.removeEventListener(MouseEvent.CLICK, this.onInput);
         this._mapBtn.removeEventListener(MouseEvent.CLICK, this.onMap);
         this._quickWordBtn.removeEventListener(MouseEvent.CLICK, this.onQuickWord);
         this._emotionBtn.removeEventListener(MouseEvent.CLICK, this.onEmotion);
         this._danceBtn.removeEventListener(MouseEvent.CLICK, this.onDance);
         this._aimatBtn.removeEventListener(MouseEvent.CLICK, this.onAimat);
         this._imBtn.removeEventListener(MouseEvent.CLICK, this.onIm);
         this._bagBtn.removeEventListener(MouseEvent.CLICK, this.onBag);
         this._petBtn.removeEventListener(MouseEvent.CLICK, this.onShowPet);
         this._showChatBtn.removeEventListener(MouseEvent.CLICK, this.onShowChat);
         this._chatPanel.removeEventListener(Event.CLOSE, this.onChatClose);
         this._homeBtn.removeEventListener(MouseEvent.CLICK, this.onGoHome);
         this._teamBtn.removeEventListener(MouseEvent.CLICK, this.onTeam);
         this._soundController_mc.removeEventListener(MouseEvent.CLICK, this.onMusicMcClickHandler);
         this._nonoBtn.removeEventListener(MouseEvent.CLICK, this.onNonoList);
         MessageManager.removeEventListener(RobotEvent.ADD_FRIEND_MSG, this.onAddFriend);
         MessageManager.removeEventListener(RobotEvent.ADD_TEAM_MSG, this.onInviteJoinTeam);
         ToolTipManager.remove(this._soundController_mc);
         ToolTipManager.remove(this._mapBtn);
         ToolTipManager.remove(this._quickWordBtn);
         ToolTipManager.remove(this._emotionBtn);
         ToolTipManager.remove(this._danceBtn);
         ToolTipManager.remove(this._aimatBtn);
         ToolTipManager.remove(this._bagBtn);
         ToolTipManager.remove(this._imBtn);
         ToolTipManager.remove(this._homeBtn);
         ToolTipManager.remove(this._petBtn);
      }

      private function onKeyBoardInput(e:KeyboardEvent):void
      {
         if (e.keyCode == Keyboard.ENTER)
         {
            this.onInput(null);
         }
      }

      private function onInput(e:MouseEvent):void
      {
         if (!this._isSend)
         {
            return;
         }
         this._isSend = false;
         MainManager.actorModel.chatAction(this._inputTxt.text);
         this._inputTxt.text = "";
         setTimeout(function():void
            {
               _isSend = true;
            }, 1000);
      }

      private function onMap(e:MouseEvent):void
      {
         WorldMapController.show();
      }

      private function onQuickWord(e:MouseEvent):void
      {
         QuickWordController.show(e.currentTarget as DisplayObject);
      }

      private function onEmotion(e:MouseEvent):void
      {
         EmotionController.show(e.currentTarget as DisplayObject);
      }

      private function onDance(e:MouseEvent):void
      {
         e.stopImmediatePropagation();
         ActorActionManager.showMenu(this._danceBtn);
      }

      private function onAimat(e:MouseEvent):void
      {
         e.stopImmediatePropagation();
         var btn:SimpleButton = e.currentTarget as SimpleButton;
         AimatGridPanel.show(btn);
      }

      private function onIm(e:MouseEvent):void
      {
         IMController.show();
      }

      private function onBag(event:MouseEvent):void
      {
         if(!ItemTipXMLInfo.isSetup)
         {
            ItemTipXMLInfo.setup(BagController.show)
         }
         else
         {
            BagController.show();
         }
      }

      private function onGoHome(event:MouseEvent):void
      {
         MapManager.changeMap(MainManager.actorID);
      }

      private function onTeam(event:MouseEvent):void
      {
         if (MainManager.actorInfo.teamInfo.id == 0)
         {
            Alarm.show("您还没有加入战队");
         }
         else
         {
            TeamController.enter(MainManager.actorInfo.teamInfo.id);
         }
      }

      private function onShowPet(event:MouseEvent):void
      {
         PetBagController.show();
      }

      private function onShowChat(e:MouseEvent):void
      {
         DisplayUtil.removeForParent(this._showChatBtn);
         this._chatPanel.show();
      }

      private function onChatClose(e:Event):void
      {
         this._mainUI.addChild(this._showChatBtn);
      }

      private function onNonoList(e:MouseEvent):void
      {
         (this._nonoIcon["tooltip_mc"]["mc"]["txt"] as TextField).htmlText = "";
         this._nonoIcon["tooltip_mc"].gotoAndStop(1);
         var so:SharedObject = SOManager.getUserSO("superNono");
         so.data["version"] = ClientConfig.superNoNo;
         DisplayUtil.removeForParent(this._nonoBtn["nonoNewMC"]);
         SpecialIconController.show(e.currentTarget as DisplayObject);
      }

      private function onAddFriend(evt:RobotEvent):void
      {
         this._imBtn.gotoAndStop(2);
         this._imBtn.addEventListener(MouseEvent.ROLL_OVER, this.showAddFrindPanel);
         this._imBtn.addEventListener(MouseEvent.ROLL_OUT, this.hideAddFrindPanel);
      }

      private function showAddFrindPanel(evt:MouseEvent):void
      {
         var name:String = null;
         this._imBtn.removeEventListener(MouseEvent.ROLL_OVER, this.showAddFrindPanel);
         this._addFriendBtn.buttonMode = true;
         this._addFriendBtn.visible = true;
         var txt:TextField = this._addFriendBtn["txt"];
         txt.mouseEnabled = false;
         if (MessageManager.friendAddInfoMap.length > 1)
         {
            txt.htmlText = "有<font color=\'#ff0000\'>" + MessageManager.friendAddInfoMap.length + "</font>个赛尔添加你为好友";
         }
         else
         {
            name = (MessageManager.friendAddInfoMap.getValues()[0] as InformInfo).nick;
            txt.htmlText = "<font color=\'#ff0000\'>" + name + "</font>想要添加你为好友";
         }
         this._addFriendBtn.addEventListener(MouseEvent.CLICK, this.showAddFridMsgPanel);
      }

      private function hideAddFrindPanel(evt:MouseEvent):void
      {
         setTimeout(function():void
            {
               _addFriendBtn.visible = false;
            }, 2000);
         this._imBtn.addEventListener(MouseEvent.ROLL_OVER, this.showAddFrindPanel);
      }

      private function showAddFridMsgPanel(evt:MouseEvent):void
      {
         this._imBtn.removeEventListener(MouseEvent.ROLL_OVER, this.showAddFrindPanel);
         this._imBtn.removeEventListener(MouseEvent.ROLL_OUT, this.hideAddFrindPanel);
         this._addFriendBtn.visible = false;
         this._addFriendBtn.removeEventListener(MouseEvent.CLICK, this.showAddFridMsgPanel);
         this._imBtn.gotoAndStop(1);
         AddFriendMsgController.showAddFridPanel();
      }

      private function onAnswerFriend(evt:RobotEvent):void
      {
         var txt:TextField = null;
         this._imBtn.gotoAndStop(2);
         txt = this._addFriendBtn["txt"];
         txt.mouseEnabled = false;
         this._imBtn.addEventListener(MouseEvent.ROLL_OVER, function(evt:MouseEvent):void
            {
               var arr:Array = null;
               var count:uint = 0;
               var timer:Timer = null;
               var show:Function = function(info:InformInfo):void
               {
                  var name:String = info.nick;
                  if (info.accept == 1)
                  {
                     txt.htmlText = "成功添加<font color=\'#ff0000\'>" + name + "</font>为好友";
                  }
                  else
                  {
                     txt.htmlText = "<font color=\'#ff0000\'>" + name + "</font>拒绝成为你的好友";
                  }
               };
               _imBtn.removeEventListener(MouseEvent.ROLL_OVER, arguments.callee);
               _addFriendBtn.visible = true;
               _addFriendBtn.mouseEnabled = false;
               _addFriendBtn.buttonMode = false;
               _addFriendBtn.mouseChildren = false;
               arr = MessageManager.friendAnswerInfoMap.getValues();
               count = 0;
               timer = new Timer(2000, arr.length);
               timer.addEventListener(TimerEvent.TIMER, function(evt:TimerEvent):void
                  {
                     show(arr[count]);
                     MessageManager.friendAnswerInfoMap.remove(arr[count].userID);
                     if (count == arr.length)
                     {
                        timer.removeEventListener(TimerEvent.TIMER, arguments.callee);
                        _addFriendBtn.visible = false;
                     }
                     ++count;
                  });
            });
      }

      private function onRemoveFriend(evt:RobotEvent):void
      {
         var txt:TextField = null;
         this._imBtn.gotoAndStop(2);
         txt = this._addFriendBtn["txt"];
         txt.mouseEnabled = false;
         this._imBtn.addEventListener(MouseEvent.ROLL_OVER, function(evt:MouseEvent):void
            {
               var arr:Array = null;
               var count:uint = 0;
               var timer:Timer = null;
               var show:Function = function(info:InformInfo):void
               {
                  var name:String = info.nick;
                  txt.htmlText = "<font color=\'#ff0000\'>" + name + "</font>从好友中删除了你";
               };
               _imBtn.removeEventListener(MouseEvent.ROLL_OVER, arguments.callee);
               _addFriendBtn.visible = true;
               _addFriendBtn.mouseEnabled = false;
               _addFriendBtn.buttonMode = false;
               _addFriendBtn.mouseChildren = false;
               arr = MessageManager.friendRemoveInfoMap.getValues();
               count = 0;
               timer = new Timer(2000, arr.length);
               timer.addEventListener(TimerEvent.TIMER, function(evt:TimerEvent):void
                  {
                     show(arr[count]);
                     MessageManager.friendRemoveInfoMap.remove(arr[count].userID);
                     ++count;
                     if (count == arr.length)
                     {
                        timer.removeEventListener(TimerEvent.TIMER, arguments.callee);
                        _addFriendBtn.visible = false;
                     }
                  });
            });
      }

      private function onInviteJoinTeam(evt:RobotEvent):void
      {
         this._teamBtn.gotoAndStop(2);
         this._teamBtn.addEventListener(MouseEvent.ROLL_OVER, this.showJoinTeamPanel);
         this._teamBtn.addEventListener(MouseEvent.ROLL_OUT, this.hideJoinTeamPanel);
      }

      private function showJoinTeamPanel(evt:MouseEvent):void
      {
         var name:String = null;
         this._teamBtn.removeEventListener(MouseEvent.ROLL_OVER, this.showJoinTeamPanel);
         this._addTeamBtn.buttonMode = true;
         this._addTeamBtn.visible = true;
         var txt:TextField = this._addTeamBtn["txt"];
         txt.mouseEnabled = false;
         if (MessageManager.inviteJoinTeamMap.length > 1)
         {
            txt.htmlText = "有<font color=\'#ff0000\'>" + MessageManager.inviteJoinTeamMap.length + "</font>个赛尔邀请你加入战队";
         }
         else
         {
            name = (MessageManager.inviteJoinTeamMap.getValues()[0] as TeamInformInfo).nick;
            txt.htmlText = "<font color=\'#ff0000\'>" + name + "</font>邀请你加入战队";
         }
         this._addTeamBtn.addEventListener(MouseEvent.CLICK, this.showAddTeamMsgPanel);
      }

      private function hideJoinTeamPanel(evt:MouseEvent):void
      {
         setTimeout(function():void
            {
               _addTeamBtn.visible = false;
            }, 2000);
         this._teamBtn.addEventListener(MouseEvent.ROLL_OVER, this.showJoinTeamPanel);
      }

      private function showAddTeamMsgPanel(evt:MouseEvent):void
      {
         this._teamBtn.removeEventListener(MouseEvent.ROLL_OVER, this.showJoinTeamPanel);
         this._teamBtn.removeEventListener(MouseEvent.ROLL_OUT, this.hideJoinTeamPanel);
         this._addTeamBtn.visible = false;
         this._addTeamBtn.removeEventListener(MouseEvent.CLICK, this.showAddTeamMsgPanel);
         this._teamBtn.gotoAndStop(1);
         AddFriendMsgController.showInviteTeamPanel();
      }

      public function aimatOff():void
      {
         this._aimatBtn.mouseEnabled = false;
         this._aimatBtn.filters = [ColorFilter.setGrayscale()];
      }

      public function bagOff():void
      {
         this._bagBtn.mouseEnabled = false;
         this._bagBtn.filters = [ColorFilter.setGrayscale()];
      }

      public function homeOff():void
      {
         this._homeBtn.mouseEnabled = false;
         this._homeBtn.filters = [ColorFilter.setGrayscale()];
      }

      public function aimatOn():void
      {
         this._aimatBtn.mouseEnabled = true;
         this._aimatBtn.filters = [];
      }

      public function bagOn():void
      {
         this._bagBtn.mouseEnabled = true;
         this._bagBtn.filters = [];
      }

      public function homeOn():void
      {
         this._homeBtn.mouseEnabled = true;
         this._homeBtn.filters = [];
      }

      public function closeMap():void
      {
         this._mapBtn.mouseEnabled = false;
      }

      public function openMap():void
      {
         this._mapBtn.mouseEnabled = true;
      }
   }
}
