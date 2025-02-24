package com.robot.app.mapProcess
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.mode.PetModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   
   public class MapProcess_42 extends BaseMapProcess
   {
      private var cc:uint = 60;
      
      private var bmd:BitmapData;
      
      private var bg:Bitmap;
      
      private var mask_mc:Shape;
      
      private var sc:Number = 1;
      
      private var _dia_1:MovieClip;
      
      private var _dia_2:MovieClip;
      
      private var shape:Shape;
      
      private var tt:Timer;
      
      public function MapProcess_42()
      {
         super();
      }
      
      override protected function init() : void
      {
         var mode:ActorModel = MainManager.actorModel;
         var petMode:PetModel = mode.pet;
         if(Boolean(petMode))
         {
            if(PetXMLInfo.getType(petMode.info.petID) == "16")
            {
               this.sc = 1.5;
            }
         }
         conLevel["talkMC"].visible = false;
         conLevel["ddMc"].visible = false;
         this.shape = new Shape();
         this.shape.graphics.beginFill(0,0.8);
         this.shape.graphics.drawRect(0,0,MainManager.getStageWidth(),MainManager.getStageHeight());
         this.shape.graphics.endFill();
         LevelManager.mapLevel.addChild(this.shape);
         SocketConnection.addCmdListener(CommandID.PET_SHOW,this.onPetShow);
         this._dia_1 = conLevel.getChildByName("diaMc_1") as MovieClip;
         this._dia_1.visible = false;
         this._dia_2 = conLevel.getChildByName("diaMc_2") as MovieClip;
         this._dia_2.visible = false;
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         this.addBlack();
         this.cheak();
      }
      
      public function addBlack() : void
      {
         this.addBg();
         this.addMask();
      }
      
      private function onPetShow(event:SocketEvent) : void
      {
         var data:PetShowInfo = event.data as PetShowInfo;
         if(data.userID == MainManager.actorInfo.userID)
         {
            if(data.flag == 1)
            {
               if(PetXMLInfo.getType(data.petID) == "16")
               {
                  this.mask_mc.scaleX = 1.5;
                  this.mask_mc.scaleY = 1.5;
                  this.sc = 1.5;
               }
            }
            else if(PetXMLInfo.getType(data.petID) == "16")
            {
               this.mask_mc.scaleX = 1;
               this.mask_mc.scaleY = 1;
               this.sc = 1;
            }
            this.mask_mc.x = MainManager.actorModel.sprite.x - this.cc * this.sc;
            this.mask_mc.y = MainManager.actorModel.sprite.y - this.cc * this.sc - 20;
         }
      }
      
      private function onWalk(e:RobotEvent) : void
      {
         this.mask_mc.x = MainManager.actorModel.sprite.x - this.cc * this.sc;
         this.mask_mc.y = MainManager.actorModel.sprite.y - this.cc * this.sc - 20;
         if(Boolean(this.tt))
         {
            this.tt.stop();
            this.tt.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.tt = null;
         }
      }
      
      override public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_SHOW,this.onPetShow);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         this.bmd.dispose();
         this.bmd = null;
         DisplayUtil.removeForParent(this.bg);
         this.bg = null;
         DisplayUtil.removeForParent(this.mask_mc);
         this.mask_mc = null;
         DisplayUtil.removeForParent(MapManager.currentMap.spaceLevel);
         if(Boolean(this.tt))
         {
            this.tt.stop();
            this.tt.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.tt = null;
         }
         LevelManager.mapLevel.mask = null;
         LevelManager.mapLevel.cacheAsBitmap = false;
         this._dia_1 = null;
         this._dia_2 = null;
      }
      
      private function cheak() : void
      {
         if(TasksManager.getTaskStatus(8) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(8,function(arr:Array):void
            {
               if(!arr[3])
               {
                  _dia_1.visible = true;
               }
               if(!arr[4])
               {
                  _dia_2.visible = true;
               }
            });
         }
      }
      
      private function addMask() : void
      {
         this.mask_mc = new Shape();
         this.mask_mc.graphics.beginFill(0,1);
         this.mask_mc.graphics.drawCircle(this.cc,this.cc,this.cc);
         this.mask_mc.graphics.endFill();
         this.mask_mc.scaleX = this.sc;
         this.mask_mc.scaleY = this.sc;
         LevelManager.mapLevel.parent.addChild(this.mask_mc);
         this.mask_mc.x = 470 - this.cc * this.sc;
         this.mask_mc.y = 75 - this.cc * this.sc - 20;
         LevelManager.mapLevel.mask = this.mask_mc;
      }
      
      private function addBg() : void
      {
         this.bmd = new BitmapData(MainManager.getStageWidth(),MainManager.getStageHeight());
         this.bmd.draw(LevelManager.mapLevel);
         this.bg = new Bitmap();
         this.bg.bitmapData = this.bmd;
         var index:int = int(LevelManager.root.getChildIndex(LevelManager.mapLevel));
         LevelManager.root.addChildAt(this.bg,index);
         DisplayUtil.removeForParent(this.shape);
         this.shape = null;
         index = int(LevelManager.root.getChildIndex(LevelManager.toolsLevel));
         LevelManager.root.addChildAt(MapManager.currentMap.spaceLevel,index - 1);
      }
      
      private function onTimerHandler(e:TimerEvent) : void
      {
         this.tt.stop();
         this.tt.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
         this.tt = null;
         MovieClipUtil.playEndAndRemove(conLevel["ice_mc"]);
         conLevel["ice_mc"].gotoAndPlay(2);
         MainManager.actorModel.stopSpecialAct();
      }
      
      public function playAniHandler() : void
      {
         if(MainManager.actorInfo.clothIDs.indexOf(100014) == -1)
         {
            Alarm.show("矿石挖掘需要专业的" + TextFormatUtil.getRedTxt("钻头") + "，若你已从赛尔飞船" + TextFormatUtil.getRedTxt("机械室") + "找到它，快把它装备上吧！");
            return;
         }
         if(Boolean(this.tt))
         {
            return;
         }
         MainManager.actorModel.stop();
         DepthManager.bringToTop(MainManager.actorModel);
         MainManager.actorModel.specialAction(100014);
         this.tt = new Timer(10 * 1000);
         this.tt.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
         this.tt.start();
      }
      
      public function getDia_1() : void
      {
         TasksManager.complete(8,3,function(b:Boolean):void
         {
            _dia_1.visible = false;
            Alarm.show("你得到一块晶体");
         });
      }
      
      public function getDia_2() : void
      {
         TasksManager.complete(8,4,function(b:Boolean):void
         {
            _dia_2.visible = false;
            Alarm.show("你得到一块晶体");
         });
      }
   }
}

