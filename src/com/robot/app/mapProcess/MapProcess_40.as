package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.spacesurvey.SpaceSurveyTool;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.Direction;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.media.Sound;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import gs.easing.Back;
   import org.taomee.manager.DepthManager;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.ArrayUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_40 extends BaseMapProcess
   {
      private var _akxyMc:MovieClip;
      
      private var _akxyNum:int = 10;
      
      private var _time:Timer;
      
      private var _shouMc:MovieClip;
      
      private var _lightMc:MovieClip;
      
      private var _bingBlockMc:MovieClip;
      
      private var _diaMc:MovieClip;
      
      private var _boxTimer:Timer;
      
      public function MapProcess_40()
      {
         super();
      }
      
      override protected function init() : void
      {
         SpaceSurveyTool.getInstance().show("塞西利亚星");
         this._akxyMc = conLevel.getChildByName("akxyMc") as MovieClip;
         this._akxyMc.addEventListener(MouseEvent.ROLL_OVER,this.onOverAkxy);
         this._diaMc = conLevel.getChildByName("diaMc") as MovieClip;
         this._diaMc.visible = false;
         this._diaMc.mouseEnabled = false;
         this._shouMc = conLevel.getChildByName("shouMc") as MovieClip;
         this._shouMc.visible = false;
         this._bingBlockMc = conLevel.getChildByName("bingBlockMc") as MovieClip;
         this._bingBlockMc.gotoAndStop(1);
         this._lightMc = topLevel.getChildByName("lightMc") as MovieClip;
         DisplayUtil.removeForParent(this._lightMc);
         this.onChangeCloth();
         this.cheakTask();
         EventManager.addEventListener(PeopleActionEvent.CLOTH_CHANGE,this.onChangeCloth);
         this._boxTimer = new Timer(5000);
         this._boxTimer.addEventListener(TimerEvent.TIMER,this.onWBTimer);
         this._boxTimer.start();
      }
      
      private function onOverAkxy(event:MouseEvent) : void
      {
         var sound:Sound = MapLibManager.getSound("akxy_sound");
         sound.play(0,1);
      }
      
      private function onWBTimer(event:TimerEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         SpaceSurveyTool.getInstance().hide();
         this._boxTimer.removeEventListener(TimerEvent.TIMER,this.onWBTimer);
         this._boxTimer = null;
         EventManager.removeEventListener(PeopleActionEvent.CLOTH_CHANGE,this.onChangeCloth);
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         this._lightMc.addFrameScript(this._lightMc.totalFrames - 1,null);
         MainManager.actorModel.speed = ItemXMLInfo.getSpeed(MainManager.actorInfo.clothIDs);
         if(Boolean(this._time))
         {
            this._time.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this._time.stop();
            this._time = null;
         }
         this._akxyMc = null;
         this._diaMc = null;
         this._shouMc = null;
         this._lightMc = null;
         this._bingBlockMc = null;
      }
      
      private function onChangeCloth(e:Event = null) : void
      {
         if(ArrayUtil.embody(MainManager.actorInfo.clothIDs,[100087,100088,100089,100090,100091]))
         {
            MainManager.actorModel.speed = 8;
         }
         else if(Boolean(MainManager.actorModel.nono) && Boolean(MainManager.actorInfo.superNono))
         {
            MainManager.actorModel.speed = ItemXMLInfo.getSpeed(MainManager.actorInfo.clothIDs);
         }
         else
         {
            MainManager.actorModel.speed = 2;
         }
      }
      
      private function cheakTask() : void
      {
         if(TasksManager.getTaskStatus(8) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(8,function(arr:Array):void
            {
               if(Boolean(arr[0]))
               {
                  if(!arr[1])
                  {
                     AimatController.addEventListener(AimatEvent.PLAY_END,onAimat);
                     _shouMc.visible = true;
                  }
                  else
                  {
                     DisplayUtil.removeForParent(_akxyMc["stateMc"]);
                  }
               }
               if(Boolean(arr[2]))
               {
                  _diaMc.mouseEnabled = false;
               }
               else
               {
                  _diaMc.mouseEnabled = true;
                  _diaMc.visible = true;
               }
            });
         }
         else if(TasksManager.getTaskStatus(8) == TasksManager.COMPLETE)
         {
            DisplayUtil.removeForParent(this._akxyMc["stateMc"]);
         }
      }
      
      private function onAimat(e:AimatEvent) : void
      {
         var info:AimatInfo = e.info;
         if(info.userID != MainManager.actorID)
         {
         }
         if(info.id != 0)
         {
            return;
         }
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         topLevel.addChild(this._lightMc);
         this._lightMc.addFrameScript(this._lightMc.totalFrames - 1,function():void
         {
            _lightMc.addFrameScript(_lightMc.totalFrames - 1,null);
            DisplayUtil.removeForParent(_lightMc);
            DisplayUtil.removeForParent(_akxyMc["stateMc"]);
            TasksManager.complete(8,1,function(b:Boolean):void
            {
               if(b)
               {
                  NpcTipDialog.show("控制芯片被打下来了，阿克西亚好像慢慢恢复了平静。",function():void
                  {
                     NpcTipDialog.show("咕咕嘎，咕咕咕咕，咕嘎嘎咕，嘎嘎噶。\n（对不起误解你了，你要找的晶体我在溶洞和迷宫里见过，那里危险，你要小心。）",function():void
                     {
                        Alarm.show("你得到一块晶体");
                        _shouMc.visible = false;
                     },NpcTipDialog.XUAN_BING_SHOU_1);
                  },NpcTipDialog.SEER);
               }
            });
         });
         this._lightMc.gotoAndPlay(1);
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         this._time.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this._time.stop();
         this._time = null;
         this._bingBlockMc.gotoAndPlay(2);
         this._bingBlockMc.mouseEnabled = false;
         MainManager.actorModel.stopSpecialAct();
      }
      
      public function changeMap(o:MovieClip) : void
      {
         var mode:ActorModel = null;
         var shape:Shape = null;
         LevelManager.closeMouseEvent();
         mode = MainManager.actorModel;
         mode.stop();
         mode.x = o.x + o.width / 2;
         mode.y = o.y + o.height / 2;
         mode.direction = Direction.DOWN;
         shape = new Shape();
         shape.graphics.beginFill(0,0);
         shape.graphics.drawRect(0,0,200,200);
         shape.graphics.endFill();
         shape.x = mode.x - (200 - mode.width) / 2;
         shape.y = mode.y - 190;
         mode.chatAction("#2");
         mode.parent.addChild(shape);
         setTimeout(function():void
         {
            mode.mask = shape;
            var targetY:Number = mode.y + 200;
            TweenLite.to(mode,0.5,{
               "y":targetY,
               "ease":Back.easeIn,
               "onComplete":onComp
            });
         },2000);
      }
      
      private function onComp() : void
      {
         var mode:ActorModel = MainManager.actorModel;
         mode.mask = null;
         LevelManager.openMouseEvent();
         MapManager.changeMap(42);
      }
      
      public function getDia() : void
      {
         TasksManager.complete(8,2,function(b:Boolean):void
         {
            if(b)
            {
               _diaMc.visible = false;
               _diaMc.mouseEnabled = false;
               Alarm.show("你得到一块晶体");
            }
         });
      }
      
      public function onAkxy() : void
      {
         FightInviteManager.fightWithBoss("阿克希亚");
      }
      
      public function onShouHit() : void
      {
         NpcTipDialog.show("咕嘎！咕咕咕咕！咕嘎咕嘎。\n（就是你们海盗，把阿克希亚害成这样！）",function():void
         {
            NpcTipDialog.show("我是赛尔号的" + TextFormatUtil.getRedTxt(MainManager.actorInfo.nick) + "，跟着求救信号找来的。你说的海盗是不是独眼的，紫色的？",function():void
            {
               NpcTipDialog.show("咕咕！咕咕咕咕！咕嘎咕嘎。\n（是的，这么说你不是海盗，如果你能帮忙让阿克希亚平静下来我就相信你。）",function():void
               {
                  NpcTipDialog.show("我的" + TextFormatUtil.getRedTxt("激光") + "能量还不够大，要找面能" + TextFormatUtil.getRedTxt("反光的物体") + "来反射加强！",null,NpcTipDialog.SEER);
               },NpcTipDialog.XUAN_BING_SHOU_3);
            },NpcTipDialog.SEER);
         },NpcTipDialog.XUAN_BING_SHOU_2);
      }
      
      public function onBingBlockHit() : void
      {
         if(MainManager.actorInfo.clothIDs.indexOf(100014) == -1)
         {
            Alarm.show("矿石挖掘需要专业的" + TextFormatUtil.getRedTxt("钻头") + "，若你已从赛尔飞船" + TextFormatUtil.getRedTxt("机械室") + "找到它，快把它装备上吧！");
            return;
         }
         MainManager.actorModel.stop();
         DepthManager.bringToTop(MainManager.actorModel);
         MainManager.actorModel.specialAction(100014);
         this._time = new Timer(10 * 1000);
         this._time.addEventListener(TimerEvent.TIMER,this.onTimer);
         this._time.start();
      }
   }
}

