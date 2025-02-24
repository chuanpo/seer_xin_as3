package com.robot.app.mapProcess.active
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.mode.ActionSpriteModel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.MovieClipUtil;
   
   public class ActivePet extends ActionSpriteModel
   {
      private var _obj:MovieClip;
      
      private var isWalking:Boolean = false;
      
      private var isEscape:Boolean = false;
      
      private var left:PointList;
      
      private var right:PointList;
      
      private var currentPointList:PointList;
      
      private var isCanMove:Boolean = true;
      
      private var timer:Timer;
      
      private var isRightFill:Boolean = false;
      
      private var isLeftFill:Boolean = false;
      
      public function ActivePet(id:uint)
      {
         super();
         speed = 2;
         this.visible = false;
         addEventListener(Event.ENTER_FRAME,this.checkDis);
         this.left = new PointList([new Point(213,342),new Point(365,410),new Point(522,344)]);
         this.right = new PointList([new Point(522,344),new Point(365,410),new Point(213,342)]);
         this.currentPointList = this.left;
         this.x = this.left.first().x;
         this.y = this.left.first().y;
         this.timer = new Timer(3000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(id),this.onLoad,"pet");
      }
      
      public function fillLeft() : void
      {
         this.isLeftFill = true;
      }
      
      public function fillRight() : void
      {
         this.isRightFill = true;
      }
      
      private function checkDis(event:Event) : void
      {
         var dis:Number = NaN;
         var p1:Point = MainManager.actorModel.localToGlobal(new Point());
         var p2:Point = this.localToGlobal(new Point());
         dis = Point.distance(p1,p2);
         this.isCanMove = dis >= 60;
         if(this.isWalking)
         {
            if(dis < 50 && !this.isEscape)
            {
               speed = 6;
               this.isEscape = true;
               if(Point.distance(this.localToGlobal(new Point()),this.left.end()) > Point.distance(this.localToGlobal(new Point()),this.right.end()))
               {
                  _walk.execute_point(this,this.right.end());
                  this.right.setToEnd();
                  this.currentPointList = this.right;
               }
               else
               {
                  _walk.execute_point(this,this.left.end());
                  this.left.setToEnd();
                  this.currentPointList = this.left;
               }
            }
         }
      }
      
      private function onLoad(o:DisplayObject) : void
      {
         this._obj = o as MovieClip;
         this._obj.gotoAndStop(_direction);
         addChild(this._obj);
         MapManager.currentMap.depthLevel.addChild(this);
         addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         addEventListener(RobotEvent.WALK_END,this.onWalkOver);
         this.startWalk();
         this.isWalking = true;
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         if(!this.isCanMove)
         {
            return;
         }
         this.isEscape = false;
         if(this.currentPointList == this.left)
         {
            this.currentPointList = this.right;
         }
         else
         {
            this.currentPointList = this.left;
         }
         this.currentPointList.reset();
         this.visible = true;
         speed = 2;
         var next:Point = this.currentPointList.next();
         _walk.execute_point(this,next);
         this.isWalking = true;
         this.timer.stop();
      }
      
      private function startWalk() : void
      {
         this.visible = true;
         _walk.execute_point(this,this.currentPointList.next());
      }
      
      override public function set direction(dir:String) : void
      {
         if(dir == null || dir == "")
         {
            return;
         }
         if(Boolean(this._obj))
         {
            this._obj.gotoAndStop(dir);
         }
      }
      
      private function onWalkStart(e:Event) : void
      {
         var mc:MovieClip = null;
         if(Boolean(this._obj))
         {
            mc = this._obj.getChildAt(0) as MovieClip;
            if(Boolean(mc))
            {
               if(mc.currentFrame == 1)
               {
                  mc.gotoAndPlay(2);
               }
            }
         }
      }
      
      private function onWalkOver(e:Event) : void
      {
         var next:Point = this.currentPointList.next();
         if(next == this.currentPointList.first())
         {
            if(this.currentPointList == this.left && this.isRightFill)
            {
               this.yun();
               MovieClipUtil.childStop(this,1);
               return;
            }
            if(this.currentPointList == this.right && this.isLeftFill)
            {
               this.yun();
               MovieClipUtil.childStop(this,1);
               return;
            }
            this.visible = false;
            this.timer.start();
            this.isWalking = false;
         }
         else
         {
            _walk.execute_point(this,next);
         }
      }
      
      private function yun() : void
      {
         var yunMC:MovieClip = MapLibManager.getMovieClip("yun_mc");
         yunMC.y = -this.height;
         this.addChild(yunMC);
         this.buttonMode = true;
         this.mouseChildren = false;
         this.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("达比拉");
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkOver);
         removeEventListener(Event.ENTER_FRAME,this.checkDis);
      }
   }
}

import flash.geom.Point;

class PointList
{
   private var array:Array = [];
   
   private var index:uint = 0;
   
   public function PointList(arr:Array)
   {
      super();
      this.array = arr.slice();
   }
   
   public function first() : Point
   {
      return this.array[0];
   }
   
   public function next() : Point
   {
      if(this.index < this.array.length - 1)
      {
         ++this.index;
      }
      else
      {
         this.index = 0;
      }
      return this.array[this.index];
   }
   
   public function reset() : void
   {
      this.index = 0;
   }
   
   public function end() : Point
   {
      return this.array[this.array.length - 1];
   }
   
   public function setToEnd() : void
   {
      this.index = this.array.length - 1;
   }
}
