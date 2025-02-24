package com.robot.app.mapProcess.active
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.ActionSpriteModel;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ActiveBigFootOgre extends ActionSpriteModel
   {
      public static const ESCAPE_SUCCESS:String = "escape_success";
      
      private var _obj:MovieClip;
      
      private var _path:Array = [new Point(65,300),new Point(160,200),new Point(318,168)];
      
      private var _bEscape:Boolean = false;
      
      private var _hasEscape:Boolean = true;
      
      public function ActiveBigFootOgre()
      {
         super();
         this.x = 445;
         this.y = 362;
         speed = 2;
         ResourceManager.getResource("resource/bounsMovie/bigfootogre.swf",this.onLoad,"pet");
      }
      
      private function checkDis(event:Event) : void
      {
         var dis:Number = NaN;
         var p1:Point = MainManager.actorModel.localToGlobal(new Point());
         var p2:Point = this.localToGlobal(new Point());
         dis = Point.distance(p1,p2);
         if(dis < 100)
         {
            this.removeEventListener(Event.ENTER_FRAME,this.checkDis);
            speed = 6;
            this._hasEscape = false;
         }
      }
      
      private function onLoad(o:DisplayObject) : void
      {
         this._obj = o as MovieClip;
         this._obj.gotoAndStop(_direction);
         addChild(this._obj);
         MapManager.currentMap.depthLevel.addChild(this);
         this.addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         this.addEventListener(RobotEvent.WALK_END,this.onWalkOver);
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
      
      public function startWalk() : void
      {
         this.addEventListener(Event.ENTER_FRAME,this.checkDis);
         _walk.execute_point(this,this.nextPoint(),false);
         this._bEscape = true;
      }
      
      private function onWalkStart(evt:Event) : void
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
      
      private function onWalkOver(evt:Event) : void
      {
         if(this._path.length == 1)
         {
            this.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
            this.removeEventListener(RobotEvent.WALK_END,this.onWalkOver);
            if(this._hasEscape)
            {
               this._obj.gotoAndStop("watch");
               setTimeout(this.destroy,2500);
            }
            else
            {
               this.destroy();
            }
            EventManager.dispatchEvent(new DynamicEvent(ESCAPE_SUCCESS,this._hasEscape));
            return;
         }
         this._obj.gotoAndStop("watch");
         setTimeout(this.walkToNext,2500);
      }
      
      private function walkToNext() : void
      {
         _walk.execute_point(this,this.nextPoint(),false);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         DisplayUtil.removeForParent(this._obj);
         this._obj = null;
         removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         removeEventListener(RobotEvent.WALK_END,this.onWalkOver);
         removeEventListener(Event.ENTER_FRAME,this.checkDis);
      }
      
      private function nextPoint() : Point
      {
         if(this._bEscape)
         {
            this._path.splice(0,1);
         }
         return this._path[0];
      }
   }
}

