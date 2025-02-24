package com.robot.app.mapProcess
{
   import com.robot.app.task.taskUtils.taskDialog.DynamicNpcTipDialog;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.config.xml.PetBookXMLInfo;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_13 extends BaseMapProcess
   {
      private var _plMc:MovieClip;
      
      private var _powerMc:MovieClip;
      
      private var _timeMc:MovieClip;
      
      private var _dinMc:MovieClip;
      
      private var _clickTime:uint;
      
      private var _timer:Timer;
      
      private var _allTimer:uint = 5;
      
      private var handler:Function;
      
      private var petMc:MovieClip;
      
      private var _petInfo:PetShowInfo;
      
      public function MapProcess_13()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._plMc = conLevel["plMc"];
         this._plMc.addEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         this._plMc.addEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         ToolTipManager.add(this._plMc,"克洛斯鳄兰");
         for(var i1:int = 1; i1 < 7; i1++)
         {
            this.conLevel["g" + i1 + "Mc"].gotoAndStop(1);
         }
         this.conLevel["waMc"].addEventListener(MouseEvent.MOUSE_OVER,this.onWaOverHandler);
         this.conLevel["waMc"].addEventListener(MouseEvent.MOUSE_OUT,this.onWaOutHandler);
         this.conLevel["waMc"].addEventListener(MouseEvent.CLICK,this.onwaHitHandler);
         this.conLevel["waMc"].buttonMode = true;
         ToolTipManager.add(this.conLevel["waMc"],"地心能量池");
         this.conLevel["lightMc"].addEventListener(MouseEvent.MOUSE_OVER,this.onLightOverHandler);
         this.conLevel["lightMc"].addEventListener(MouseEvent.MOUSE_OUT,this.onLightOutHandler);
         this.conLevel["lightMc1"].visible = false;
         ToolTipManager.add(conLevel["lightMc"],"克洛斯金刚石");
      }
      
      private function onLightOverHandler(e:MouseEvent) : void
      {
         this.conLevel["light1"].gotoAndPlay(2);
         this.conLevel["light2"].gotoAndPlay(2);
      }
      
      private function onLightOutHandler(e:MouseEvent) : void
      {
         ToolTipManager.add(conLevel["lightMc"],"克洛斯金刚石");
         this.conLevel["light1"].gotoAndStop(2);
         this.conLevel["light2"].gotoAndStop(2);
         Mouse.show();
         if(Boolean(this._dinMc))
         {
            this._dinMc.removeEventListener(MouseEvent.CLICK,this.onDinClickHandler);
            DisplayUtil.removeForParent(this._dinMc);
            this._dinMc = null;
         }
      }
      
      private function onWaOverHandler(e:MouseEvent) : void
      {
         var index:uint = uint(uint(Math.random() * 6) + 1);
         this._powerMc = conLevel["g" + index + "Mc"];
         this._powerMc.gotoAndPlay(2);
      }
      
      private function onWaOutHandler(e:MouseEvent) : void
      {
         if(Boolean(this._powerMc))
         {
            this._powerMc.gotoAndStop(1);
         }
      }
      
      private function onOverHandler(e:MouseEvent) : void
      {
         this._plMc.gotoAndStop(2);
      }
      
      private function onOutHandler(e:MouseEvent) : void
      {
         this._plMc.gotoAndStop(1);
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(conLevel["waMc"]);
         this.conLevel["waMc"].removeEventListener(MouseEvent.CLICK,this.onwaHitHandler);
         this.conLevel["waMc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onWaOverHandler);
         this.conLevel["waMc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onWaOutHandler);
         this.conLevel["lightMc"].removeEventListener(MouseEvent.MOUSE_OVER,this.onLightOverHandler);
         this.conLevel["lightMc"].removeEventListener(MouseEvent.MOUSE_OUT,this.onLightOutHandler);
         ToolTipManager.remove(this._plMc);
         ToolTipManager.remove(this.conLevel["lightMc"]);
         this._plMc.removeEventListener(MouseEvent.MOUSE_OVER,this.onOverHandler);
         this._plMc.removeEventListener(MouseEvent.MOUSE_OUT,this.onOutHandler);
         this._plMc.removeEventListener(Event.CLOSE,this.onCloseHandler);
         this._plMc = null;
         if(Boolean(this._dinMc))
         {
            this._dinMc.removeEventListener(MouseEvent.CLICK,this.onDinClickHandler);
            DisplayUtil.removeForParent(this._dinMc);
            this._dinMc = null;
         }
         if(Boolean(this._timeMc))
         {
            DisplayUtil.removeForParent(this._timeMc);
            this._timeMc = null;
         }
         if(Boolean(this._timer))
         {
            this._timer.stop();
            this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this._timer = null;
         }
      }
      
      public function onPlHandler() : void
      {
         if(MainManager.actorModel.nono == null)
         {
            if(MainManager.actorInfo.superNono)
            {
               NpcTipDialog.show("请带上你的超能NoNo再来吧！",null,NpcTipDialog.NONO);
            }
            else
            {
               NpcTipDialog.show("请带上你的NoNo再来吧！",null,NpcTipDialog.NONO);
            }
            return;
         }
         this.conLevel["plMc"].mouseEnabled = false;
         this.conLevel["plMc"].mouseChildren = false;
      }
      
      private function onCloseHandler(e:Event) : void
      {
         this._plMc.addEventListener(Event.CLOSE,this.onCloseHandler);
         MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
         this._plMc.gotoAndStop(1);
         this.conLevel["plMc"].mouseEnabled = true;
         this.conLevel["plMc"].mouseChildren = true;
         if(!MainManager.actorInfo.superNono)
         {
            NpcTipDialog.show("O(∩_∩)O别担心，克洛斯鳄兰的消化液对NoNo的机体没有伤害，还能为NoNo补充能量，看你的NoNo充满能量了哦！",null,NpcTipDialog.NONO);
         }
         else
         {
            NpcTipDialog.show("O(∩_∩)O别担心，克洛斯鳄兰的消化液对NoNo的机体没有伤害，还能为NoNo补充精神，看你的NoNo精神满满了哟！",null,NpcTipDialog.NONO);
         }
      }
      
      public function onLightHandler() : void
      {
         if(!MainManager.actorInfo.superNono)
         {
            DynamicNpcTipDialog.show("这里是克洛斯星地心的重要结构层：克洛斯金刚石层。只有" + TextFormatUtil.getRedTxt("超能NoNo") + "可以帮你获得这些珍贵的矿石哟！",function():void
            {
               var r:VipSession = new VipSession();
               r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
               {
               });
               r.getSession();
            },NpcTipDialog.NONO);
            return;
         }
         if(MainManager.actorModel.nono == null)
         {
            if(MainManager.actorInfo.superNono)
            {
               NpcTipDialog.show("请带上你的超能NoNo再来吧！",null,NpcTipDialog.NONO);
            }
            return;
         }
         NpcTipDialog.show("这里是克洛斯星地心的重要结构层：克洛斯金刚石层。克洛斯地心的这个结构支持着克洛斯星地壳以防下沉，是非常重要的结构呢。",this.showDia,NpcTipDialog.NONO);
      }
      
      private function showDia() : void
      {
         NpcTipDialog.show("巨大的压力让金刚石层的密度变得很高，成为非常有价值的矿产！从现在开始，NoNo会化身为" + TextFormatUtil.getRedTxt("能量吸收器") + "，你可以用它放在金刚石层" + TextFormatUtil.getRedTxt("迅速敲击") + "就可以吸收金刚石碎末，将它带回飞船！",this.startExp,NpcTipDialog.NONO);
      }
      
      private function startExp() : void
      {
         MainManager.actorModel.hideNono();
         if(!this._timeMc)
         {
            this._timeMc = MapLibManager.getMovieClip("TimeMc");
            LevelManager.appLevel.addChild(this._timeMc);
            this._timeMc["mc"].gotoAndStop(5);
            this._timeMc.x = 450;
            this._timeMc.y = 10;
            this._allTimer = 5;
            this._timer = new Timer(1000);
            this._timer.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this._timer.start();
         }
         this.conLevel["lightMc1"].visible = true;
         this.conLevel["lightMc"].visible = false;
         this.conLevel["lightMc1"].addEventListener(MouseEvent.MOUSE_OVER,this.onLightOver1Handler);
      }
      
      private function onLightOver1Handler(e:MouseEvent) : void
      {
         Mouse.hide();
         if(!this._dinMc)
         {
            this._dinMc = MapLibManager.getMovieClip("ExcavateMc");
            this._dinMc.gotoAndStop(1);
            LevelManager.appLevel.addChild(this._dinMc);
            this._clickTime = 0;
            this._dinMc.addEventListener(MouseEvent.CLICK,this.onDinClickHandler);
         }
         this._dinMc.x = LevelManager.stage.mouseX - this._dinMc.width / 2;
         this._dinMc.y = LevelManager.stage.mouseY - this._dinMc.height / 2;
      }
      
      private function onDinClickHandler(e:MouseEvent) : void
      {
         ++this._clickTime;
         this._dinMc.gotoAndPlay(2);
      }
      
      private function onTimerHandler(e:TimerEvent) : void
      {
         --this._allTimer;
         if(Boolean(this._timeMc))
         {
            if(this._allTimer > 0)
            {
               this._timeMc["mc"].gotoAndStop(this._allTimer);
            }
            else
            {
               this._timeMc["mc"].gotoAndStop(1);
            }
         }
         if(this._allTimer == 0)
         {
            this._timer.stop();
            Mouse.show();
            conLevel["lightMc1"].removeEventListener(MouseEvent.MOUSE_OVER,this.onLightOver1Handler);
            if(this._clickTime == 0)
            {
               this.des();
               NpcTipDialog.show("     很遗憾你没有采集！加油...",null,NpcTipDialog.NONO);
               conLevel["lightMc1"].visible = false;
               conLevel["lightMc"].visible = true;
               ToolTipManager.add(conLevel["lightMc"],"克洛斯金刚石");
               return;
            }
         }
      }
      
      private function des() : void
      {
         MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
         if(Boolean(this._dinMc))
         {
            this._dinMc.removeEventListener(MouseEvent.CLICK,this.onDinClickHandler);
            DisplayUtil.removeForParent(this._dinMc);
            this._dinMc = null;
         }
         if(Boolean(this._timeMc))
         {
            DisplayUtil.removeForParent(this._timeMc);
            this._timeMc = null;
         }
      }
      
      public function onwaHitHandler(e:MouseEvent) : void
      {
         var petId:uint;
         var type:String;
         if(MainManager.actorModel.pet == null)
         {
            if(MainManager.actorInfo.superNono)
            {
               NpcTipDialog.show("这里是克洛斯星地心的核心结构：地心能量池克洛斯星所有的能源都来自于此，而克洛斯星的精灵们就是这个能量池的构造者。",function():void
               {
                  NpcTipDialog.show("O(∩_∩)O只有" + TextFormatUtil.getRedTxt("草系精灵") + "可以吸收克洛斯星精灵们千百年来积攒的能量精华哦！",null,NpcTipDialog.NONO);
               },NpcTipDialog.NONO);
            }
            else
            {
               DynamicNpcTipDialog.show("这里是克洛斯星地心的重要结构层：地心能量池。只有" + TextFormatUtil.getRedTxt("超能NoNo") + "可以帮你的精灵从这里提取能量，你想为自己NoNo充能让它成为超能NoNo吗？",function():void
               {
                  var r:VipSession = new VipSession();
                  r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
                  {
                  });
                  r.getSession();
               },NpcTipDialog.NONO);
            }
            return;
         }
         petId = uint(MainManager.actorModel.pet.info.petID);
         type = PetBookXMLInfo.getType(petId);
         if(MainManager.actorInfo.superNono)
         {
            if(type == "草")
            {
               this.conLevel["waMc"].removeEventListener(MouseEvent.CLICK,this.onwaHitHandler);
            }
            else
            {
               NpcTipDialog.show("O(∩_∩)O只有" + TextFormatUtil.getRedTxt("草系精灵") + "可以吸收克洛斯星精灵们千百年来积攒的能量精华哦！",null,NpcTipDialog.NONO);
            }
         }
      }
      
      private function onEnterHandler(e:Event) : void
      {
         var ml:MLoadPane = null;
         if(conLevel["aiMc"].currentFrame == 38)
         {
            if(Boolean(conLevel["aiMc"]["mc"]["mc"]))
            {
               DisplayUtil.stopAllMovieClip(this.petMc);
               ml = new MLoadPane(this.petMc);
               if(this.petMc.width > this.petMc.height)
               {
                  ml.fitType = MLoadPane.FIT_WIDTH;
               }
               else
               {
                  ml.fitType = MLoadPane.FIT_HEIGHT;
               }
               ml.setSizeWH(70,70);
               ml.x = 10;
               ml.y = 10;
               conLevel["aiMc"]["mc"]["mc"].addChildAt(ml,0);
            }
         }
         if(conLevel["aiMc"].currentFrame == conLevel["aiMc"].totalFrames)
         {
            if(this.handler != null)
            {
               this.handler();
               this.handler = null;
            }
            conLevel["aiMc"].removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
            conLevel["aiMc"].gotoAndStop(1);
            MainManager.actorModel.showPet(this._petInfo);
            this.conLevel["waMc"].addEventListener(MouseEvent.CLICK,this.onwaHitHandler);
         }
      }
   }
}

