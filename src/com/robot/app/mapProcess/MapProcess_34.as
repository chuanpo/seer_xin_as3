package com.robot.app.mapProcess
{
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.UnbelievableSpriteScholar.OpenTempleDoorController;
   import com.robot.app.task.process.TaskProcess_11;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.OgreModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_34 extends BaseMapProcess
   {
      private var _currYin:MovieClip;
      
      private var _currIndex:int = 0;
      
      private var mcA:Array;
      
      private var hitA:Array;
      
      private var curNameIndex:Number;
      
      private var curMc:MovieClip;
      
      private var curPoint:Point;
      
      private var time:uint = 0;
      
      private var _yaModel:OgreModel;
      
      private var shitou:MovieClip;
      
      private var xiangzi:MovieClip;
      
      public function MapProcess_34()
      {
         super();
      }
      
      override protected function init() : void
      {
         var name:String = null;
         var mc:MovieClip = null;
         var i1:uint = 0;
         conLevel["lidMc"].gotoAndPlay(60);
         ToolTipManager.add(conLevel["door_0"],"神秘通道");
         for(var i:int = 0; i < 3; i++)
         {
            conLevel["yin_" + i.toString()].gotoAndStop(1);
            conLevel["yin_" + i.toString()].visible = false;
         }
         this._currYin = conLevel["yin_" + this._currIndex.toString()];
         conLevel["treeMc"].buttonMode = true;
         conLevel["treeMc"].addEventListener(MouseEvent.CLICK,this.onTreeHandler);
         DisplayUtil.removeForParent(conLevel["tengmanMC"]);
         DisplayUtil.removeForParent(conLevel["templeDoorMC"]);
         DisplayUtil.removeForParent(conLevel["huahuaguoMC"]);
         for(var j:uint = 0; j < 6; j++)
         {
            name = "matter_" + j;
            mc = MapManager.currentMap.depthLevel.getChildByName(name) as MovieClip;
            DisplayUtil.removeForParent(mc);
            mc = null;
         }
         var mc_suc:MovieClip = MapManager.currentMap.depthLevel.getChildByName("chosSuccseMC") as MovieClip;
         DisplayUtil.removeForParent(mc_suc);
         mc_suc = null;
         var mc_false:MovieClip = MapManager.currentMap.depthLevel.getChildByName("chosFalseMC") as MovieClip;
         DisplayUtil.removeForParent(mc_false);
         mc_false = null;
         this.shitou = conLevel["shitou"] as MovieClip;
         this.shitou.visible = false;
         this.xiangzi = conLevel["xiangzi"] as MovieClip;
         this.xiangzi.alpha = 0;
         if(TasksManager.getTaskStatus(12) == TasksManager.COMPLETE)
         {
            this.check();
            animatorLevel.visible = false;
            for(i1 = 1; i1 < 5; i1++)
            {
               conLevel["mc" + i1].visible = false;
               conLevel["hit" + i1].gotoAndPlay(2);
               conLevel["treeMc"].gotoAndStop(4);
            }
            return;
         }
         if(TasksManager.getTaskStatus(12) == TasksManager.ALR_ACCEPT)
         {
            this.configStone();
            return;
         }
         if(TasksManager.getTaskStatus(12) == TasksManager.UN_ACCEPT)
         {
            TasksManager.accept(12,this.acHandler);
            return;
         }
      }
      
      private function acHandler(b1:Boolean) : void
      {
         if(b1)
         {
            this.configStone();
         }
      }
      
      private function configStone() : void
      {
         this.mcA = [1,2,3,4];
         this.hitA = [1,2,3,4];
         this.time = 0;
         for(var i1:uint = 1; i1 < 5; i1++)
         {
            conLevel["mc" + i1].buttonMode = true;
            conLevel["mc" + i1].addEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
         }
      }
      
      private function onTreeHandler(e:MouseEvent) : void
      {
         ++this.time;
         if(this.time > 3)
         {
            return;
         }
         conLevel["treeMc"].gotoAndStop(this.time + 1);
         if(this.time == 3)
         {
            conLevel["mc4"].gotoAndPlay(2);
         }
      }
      
      public function clickTengman() : void
      {
      }
      
      public function clickTempleDoor() : void
      {
         OpenTempleDoorController.show();
      }
      
      public function oreHandler() : void
      {
         var alice:String = NpcTipDialog.IRIS;
         NpcTipDialog.show("神秘的精灵圣殿被奇怪的晶体藤蔓缠绕着无法开启，得到电能锯子的赛尔们，快来帮忙吧！采集到的藤结晶可以拿到动力室换取赛尔豆哦！",this.handler,alice);
      }
      
      private function handler() : void
      {
         EnergyController.exploit();
      }
      
      private function onDownHandler(e:MouseEvent) : void
      {
         this.curPoint = new Point();
         this.curNameIndex = Number((e.currentTarget as MovieClip).name.slice(2,3));
         this.curMc = e.currentTarget as MovieClip;
         this.curPoint.x = e.currentTarget.x;
         this.curPoint.y = e.currentTarget.y;
         this.curMc.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUphandler);
      }
      
      private function onUphandler(e:MouseEvent) : void
      {
         var index:int = 0;
         this.curMc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUphandler);
         for(var i1:uint = 0; i1 < this.hitA.length; i1++)
         {
            if(this.curMc.hitTestObject(conLevel["hit" + this.hitA[i1]]))
            {
               conLevel["hit" + this.hitA[i1]].gotoAndPlay(2);
               this.curMc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
               DisplayUtil.removeForParent(this.curMc);
               this.curMc = null;
               index = int(this.hitA.indexOf(this.hitA[i1]));
               this.hitA.splice(index,1);
               index = int(this.mcA.indexOf(this.curNameIndex));
               this.mcA.splice(index,1);
               if(this.hitA.length == 0)
               {
                  if(TasksManager.getTaskStatus(12) != TasksManager.COMPLETE)
                  {
                     TasksManager.complete(12,1);
                  }
                  animatorLevel.visible = false;
                  this.check();
               }
               return;
            }
         }
         this.curMc.x = this.curPoint.x;
         this.curMc.y = this.curPoint.y;
      }
      
      override public function destroy() : void
      {
         var i1:int = 0;
         ToolTipManager.remove(conLevel["door_0"]);
         this.onMapDown();
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimatEnd);
         this._currYin.removeEventListener(Event.ENTER_FRAME,this.onYinEnter);
         this._currYin.stop();
         this._currYin = null;
         if(Boolean(this.mcA))
         {
            if(this.mcA.length > 0)
            {
               for(i1 = 0; i1 < this.mcA.length; i1++)
               {
                  conLevel["mc" + this.mcA[i1]].removeEventListener(MouseEvent.MOUSE_DOWN,this.onDownHandler);
               }
            }
         }
         if(Boolean(this._yaModel))
         {
            this._yaModel.removeEventListener(RobotEvent.OGRE_CLICK,this.onYaClick);
            this._yaModel.destroy();
            this._yaModel = null;
         }
      }
      
      private function check() : void
      {
         if(TaskProcess_11.isCatch)
         {
            return;
         }
         if(TasksManager.getTaskStatus(11) != TasksManager.COMPLETE)
         {
            this._currYin.gotoAndPlay(2);
            this._currYin.visible = true;
            this._currYin.addEventListener(Event.ENTER_FRAME,this.onYinEnter);
            TaskProcess_11.start();
            AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimatEnd);
         }
      }
      
      private function onYinEnter(e:Event) : void
      {
         if(this._currYin.currentFrame == this._currYin.totalFrames)
         {
            this._currYin.removeEventListener(Event.ENTER_FRAME,this.onYinEnter);
            this._currYin.gotoAndStop(1);
            this._currYin.visible = false;
            ++this._currIndex;
            if(this._currIndex >= 3)
            {
               this._currIndex = 0;
            }
            this._currYin = conLevel["yin_" + this._currIndex.toString()];
            this._currYin.addEventListener(Event.ENTER_FRAME,this.onYinEnter);
            this._currYin.gotoAndPlay(2);
            this._currYin.visible = true;
         }
      }
      
      private function onAimatEnd(e:AimatEvent) : void
      {
         var info:AimatInfo = e.info;
         if(info.userID == MainManager.actorID)
         {
            if(info.id == 10003)
            {
               if(Boolean(this._currYin))
               {
                  if(this._currYin.hitTestPoint(info.endPos.x,info.endPos.y))
                  {
                     this._currYin.removeEventListener(Event.ENTER_FRAME,this.onYinEnter);
                     this._currYin.gotoAndStop(1);
                     this._currYin.visible = false;
                     this._yaModel = new OgreModel(0);
                     this._yaModel.show(74,info.endPos);
                     this._yaModel.addEventListener(RobotEvent.OGRE_CLICK,this.onYaClick);
                  }
               }
            }
         }
      }
      
      private function onYaClick(e:Event) : void
      {
         if(Point.distance(this._yaModel.pos,MainManager.actorModel.pos) < 40)
         {
            MainManager.actorModel.stop();
            FightInviteManager.fightWithBoss("果冻鸭");
            return;
         }
         MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
         MainManager.actorModel.walkAction(this._yaModel.pos);
      }
      
      private function onWalkEnter(e:Event) : void
      {
         if(Point.distance(this._yaModel.pos,MainManager.actorModel.pos) < 40)
         {
            this.onMapDown();
            MainManager.actorModel.stop();
            FightInviteManager.fightWithBoss("果冻鸭");
         }
      }
      
      private function onMapDown(e:MapEvent = null) : void
      {
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalkEnter);
      }
      
      public function changeToHandler() : void
      {
         conLevel["lidMc"].addEventListener(Event.ENTER_FRAME,this.onEntHandler);
         conLevel["lidMc"].gotoAndPlay(60);
      }
      
      private function onEntHandler(e:Event) : void
      {
         if(conLevel["lidMc"].currentFrame == 70)
         {
            conLevel["lidMc"].removeEventListener(Event.ENTER_FRAME,this.onEntHandler);
            MapManager.changeMap(33);
         }
      }
      
      public function onClickShitou() : void
      {
      }
      
      private function onClickXiangzi(evt:MouseEvent) : void
      {
         this.xiangzi.removeEventListener(MouseEvent.CLICK,this.onClickXiangzi);
         DisplayUtil.removeForParent(this.shitou);
         this.shitou = null;
         DisplayUtil.removeForParent(this.xiangzi);
         this.xiangzi = null;
         NpcTipDialog.show("恭喜你已经找到了遗迹宝箱，据这些机械残骸看来可能是属于机械精灵的，不过我们现在还缺少机械图纸，再去<font color=\'#ff0000\'>赫尔卡星</font>其他地方找找吧",null,NpcTipDialog.DOCTOR,-80);
         TasksManager.complete(28,0);
      }
   }
}

