package com.robot.core.aticon
{
   import com.robot.core.CommandID;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.IActionSprite;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.EmptySkeletonStrategy;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import gs.TweenMax;
   import gs.events.TweenEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class FlyAction implements IWalk
   {
      private var _isPlaying:Boolean = false;
      
      private var _obj:IActionSprite;
      
      private var _startPoint:Point;
      
      private var _endPoint:Point;
      
      private var _curvePoint:Point;
      
      private var _speed:Number = 150;
      
      private const MIN_DISTANCE:uint = 100;
      
      private var _time:Number;
      
      private var _tween:TweenMax;
      
      private var _flyMachineMc:MovieClip;
      
      private var _pe:PeculiarAction;
      
      private var _color:uint;
      
      private var _isFly:Boolean;
      
      private var _skele:EmptySkeletonStrategy;
      
      private var _isNet:Boolean;
      
      private const CURVE:Number = 2.5;
      
      public function FlyAction(obj:IActionSprite)
      {
         super();
         this.init();
         this._obj = obj;
         this._isNet = false;
         this._isFly = false;
         this._skele = (this._obj as BasePeoleModel).skeleton as EmptySkeletonStrategy;
         if(Boolean((this._obj as BasePeoleModel).nono))
         {
            (this._obj as BasePeoleModel).nono.direction = (this._obj as BasePeoleModel).direction;
         }
         if((this._obj as BasePeoleModel).info.userID == MainManager.actorID)
         {
            (this._obj as ActorModel).footMC.visible = false;
         }
         (this._obj as BasePeoleModel).nameTxt.y += 40;
         this._pe = new PeculiarAction();
         this._pe.keepDown(this._skele);
      }
      
      public function execute_point(obj:IActionSprite, endPos:Point, isNet:Boolean = true) : void
      {
      }
      
      public function get endP() : Point
      {
         return this._endPoint;
      }
      
      public function get remData() : Array
      {
         return new Array();
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function get endPoint() : Point
      {
         return this._endPoint;
      }
      
      public function init() : void
      {
         this._obj = null;
         this._tween = null;
         this._startPoint = null;
         this._endPoint = null;
         this._curvePoint = null;
         this._isPlaying = false;
      }
      
      public function execute(obj:IActionSprite, endP:Object, isNet:Boolean = false) : void
      {
         var nn:uint = 0;
         if(!obj)
         {
            return;
         }
         if(!MapManager.currentMap.isBlock(endP as Point))
         {
            return;
         }
         this._isNet = isNet;
         this._obj = obj;
         this._startPoint = this._obj.pos;
         this._endPoint = endP as Point;
         DepthManager.bringToTop(this._obj.sprite);
         this._obj.direction = Direction.getStr(this._startPoint,this._endPoint);
         if(Boolean((this._obj as BasePeoleModel).nono))
         {
            nn = setTimeout(function():void
            {
               clearTimeout(nn);
               (_obj as BasePeoleModel).nono.direction = _obj.direction;
            },100);
         }
         this._time = Point.distance(this._startPoint,this._endPoint) / this._speed;
         this._curvePoint = this._startPoint;
         this._isPlaying = true;
         this.fly(this._time,this._curvePoint,this._endPoint);
      }
      
      private function fly(time:Number, curveP:Point, endP:Point) : void
      {
         if(!this._obj)
         {
            return;
         }
         (this._obj as BasePeoleModel).nono.startPlay();
         this._obj.sprite.dispatchEvent(new RobotEvent(RobotEvent.WALK_START));
         this._obj.sprite.addEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         if(Boolean(this._tween))
         {
            this._tween.pause();
            this._tween.removeEventListener(TweenEvent.COMPLETE,this.onComHandler);
            this._tween = null;
         }
         this._tween = TweenMax.to(this._obj,time,{
            "bezier":[{
               "x":curveP.x,
               "y":curveP.y
            },{
               "x":endP.x,
               "y":endP.y
            }],
            "orientToBezier":false
         });
         this._tween.addEventListener(TweenEvent.COMPLETE,this.onComHandler);
         if(this._isNet)
         {
            SocketConnection.send(CommandID.PEOPLE_WALK,1,this._endPoint.x,this._endPoint.y,0);
         }
      }
      
      private function onEnterHandler(e:Event) : void
      {
         if(Boolean(this._obj))
         {
            this._obj.sprite.dispatchEvent(new RobotEvent(RobotEvent.WALK_ENTER_FRAME));
         }
      }
      
      public function play() : void
      {
      }
      
      public function stop() : void
      {
         this._obj = null;
         if(Boolean(this._tween))
         {
            if(this._isPlaying)
            {
               this._tween.pause();
            }
            this._tween.removeEventListener(TweenEvent.COMPLETE,this.onComHandler);
            this._tween = null;
         }
      }
      
      private function onComHandler(e:TweenEvent) : void
      {
         this._obj.sprite.removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         this._tween.removeEventListener(TweenEvent.COMPLETE,this.onComHandler);
         this._isPlaying = false;
         (this._obj as BasePeoleModel).nono.stopPlay();
         this._obj.sprite.dispatchEvent(new RobotEvent(RobotEvent.WALK_END));
      }
      
      public function destroy() : void
      {
         if(Boolean(this._obj))
         {
            this._obj.sprite.removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         }
         this._obj = null;
         this._skele = null;
         if(Boolean(this._tween))
         {
            if(this._isPlaying)
            {
               this._tween.pause();
            }
            this._tween.removeEventListener(TweenEvent.COMPLETE,this.onComHandler);
            this._tween = null;
         }
         this._startPoint = null;
         this._endPoint = null;
         this._curvePoint = null;
         this._isPlaying = false;
         this._isFly = false;
         this._isNet = false;
         if(Boolean(this._flyMachineMc))
         {
            DisplayUtil.removeForParent(this._flyMachineMc);
            this._flyMachineMc = null;
         }
         this._pe = null;
      }
   }
}

