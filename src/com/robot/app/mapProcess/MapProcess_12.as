package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.skeeClothTask.SkeeClothTaskController;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_12 extends BaseMapProcess
   {
      private var stoneMC:MovieClip;
      
      private var pullArray:Array = [];
      
      private var _yiyiCount:uint;
      
      private var _yiyiMc:MovieClip;
      
      private var _yiyiTimer:uint;
      
      private var _yiyiPosList:Array = [new Point(110,160),new Point(210,140),new Point(280,140),new Point(110,260),new Point(240,250),new Point(100,325),new Point(215,350),new Point(150,395),new Point(70,440)];
      
      public function MapProcess_12()
      {
         super();
      }
      
      override protected function init() : void
      {
         var btn:SimpleButton = null;
         this.stoneMC = conLevel["stoneMC"];
         this.stoneMC.buttonMode = true;
         this.stoneMC.gotoAndStop(1);
         for(var i:uint = 0; i < 5; i++)
         {
            btn = depthLevel["sz_" + i];
            btn.addEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
         }
         this._yiyiMc = MapLibManager.getMovieClip("UI_yiyi");
         this._yiyiTimer = setInterval(this.onInTime,10000);
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
      }
      
      override public function destroy() : void
      {
         var btn:SimpleButton = null;
         this.onMapDown(null);
         clearInterval(this._yiyiTimer);
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         for(var i:uint = 0; i < 5; i++)
         {
            btn = depthLevel["sz_" + i];
            btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
         }
         this.stoneMC.removeEventListener(MouseEvent.CLICK,this.clickStone);
         this.stoneMC = null;
         this._yiyiPosList = null;
         DisplayUtil.removeForParent(this._yiyiMc);
         this._yiyiMc = null;
      }
      
      private function downHandler(event:MouseEvent) : void
      {
         if(!this.stoneMC.parent)
         {
            return;
         }
         var btn:SimpleButton = event.currentTarget as SimpleButton;
         var num:uint = uint(btn.name.substr(-1,1));
         if(this.pullArray.indexOf(num) == -1)
         {
            this.pullArray.push(num);
            this.checkPull();
         }
      }
      
      private function checkPull() : void
      {
         var i:uint = 0;
         var btn:SimpleButton = null;
         if(this.pullArray.length == 5)
         {
            this.stoneMC.play();
            this.addStoneEvent();
            this.pullArray = [];
            for(i = 0; i < 5; i++)
            {
               btn = depthLevel["sz_" + i];
               btn.removeEventListener(MouseEvent.MOUSE_DOWN,this.downHandler);
            }
         }
         else
         {
            this.stoneMC.y += 8;
         }
      }
      
      private function addStoneEvent() : void
      {
         this.stoneMC.addEventListener(MouseEvent.CLICK,this.clickStone);
      }
      
      private function clickStone(event:MouseEvent) : void
      {
      }
      
      private function onCheckTask(b:Boolean) : void
      {
         if(b)
         {
            Alarm.show("你已经收集过植物纤维了！");
         }
         else
         {
            TasksManager.complete(SkeeClothTaskController.TASK_ID,0,function(b:Boolean):void
            {
               if(b)
               {
                  Alarm.show("恭喜你找到了<font color=\'#ff0000\'>植物纤维</font>");
                  DisplayUtil.removeForParent(stoneMC);
               }
               else
               {
                  Alarm.show("这次采集似乎失败了，再尝试一次吧！");
               }
            });
         }
      }
      
      private function onAimat(e:AimatEvent) : void
      {
         var info:AimatInfo = e.info;
         if(info.userID == MainManager.actorID)
         {
            if(info.id == 10001)
            {
               if(this._yiyiMc.hitTestPoint(info.endPos.x,info.endPos.y))
               {
                  ++this._yiyiCount;
                  if(this._yiyiCount >= 3)
                  {
                     AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
                     clearInterval(this._yiyiTimer);
                     this._yiyiMc.gotoAndStop(20);
                     this._yiyiMc.buttonMode = true;
                     this._yiyiMc.addEventListener(MouseEvent.CLICK,this.onYiyiClick);
                  }
               }
            }
         }
      }
      
      private function onInTime() : void
      {
         var p:Point = null;
         if(!DisplayUtil.hasParent(this._yiyiMc))
         {
            conLevel.addChild(this._yiyiMc);
         }
         var index:int = int(this._yiyiPosList.length * Math.random());
         if(index == this._yiyiPosList.length)
         {
            index = this._yiyiPosList.length - 1;
         }
         p = this._yiyiPosList[index];
         this._yiyiMc.x = p.x;
         this._yiyiMc.y = p.y;
         this._yiyiMc.gotoAndPlay(1);
      }
      
      private function onYiyiClick(e:MouseEvent) : void
      {
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MapManager.addEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
         MainManager.actorModel.walkAction(new Point(this._yiyiMc.x,this._yiyiMc.y));
      }
      
      private function onWalk(e:Event) : void
      {
         if(Math.abs(Point.distance(new Point(this._yiyiMc.x,this._yiyiMc.y),MainManager.actorModel.pos)) < 30)
         {
            this.onMapDown(null);
            MainManager.actorModel.stop();
            FightInviteManager.fightWithBoss("依依",1);
         }
      }
      
      private function onMapDown(e:MapEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MapManager.removeEventListener(MapEvent.MAP_MOUSE_DOWN,this.onMapDown);
      }
   }
}

