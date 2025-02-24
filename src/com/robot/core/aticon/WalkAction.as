package com.robot.core.aticon
{
   import com.robot.core.CommandID;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.mode.IActionSprite;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.utils.Direction;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import org.taomee.algo.AStar;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.GeomUtil;
   
   public class WalkAction implements IWalk
   {
      private var _isPlaying:Boolean = false;
      
      private var _obj:IActionSprite;
      
      private var _path:Array;
      
      private var _length:int;
      
      private var _currentCount:uint = 0;
      
      private var _nextNum:uint;
      
      private var _disPos:Point;
      
      private var _curPos:Point;
      
      private var _nextP:Point;
      
      private var _endP:Point;
      
      private var _speed:Number;
      
      private var _count:int;
      
      public function WalkAction()
      {
         super();
      }
      
      public function init() : void
      {
         this._isPlaying = false;
         this._path = null;
         this._length = 0;
         this._currentCount = 0;
         this._curPos = null;
         this._nextP = null;
         this._endP = null;
         this._nextNum = 0;
         this._count = 0;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      public function execute(obj:IActionSprite, data:Object, isNet:Boolean = true) : void
      {
         if(data is Point)
         {
            this.execute_point(obj,data as Point,isNet);
         }
         else if(data is Array)
         {
            this.execute_array(obj,data as Array);
         }
      }
      
      public function execute_point(obj:IActionSprite, endPos:Point, isNet:Boolean = true) : void
      {
         var by:ByteArray = null;
         var paths:Array = AStar.find(obj.pos,endPos);
         if(Boolean(paths))
         {
            this.init();
            this._obj = obj;
            this._path = paths;
            this._length = this._path.length;
            this._endP = endPos;
            if(this._length > 1)
            {
               this._path[0] = this._obj.pos;
               this.play();
               if(isNet)
               {
                  by = new ByteArray();
                  by.writeObject(this._path);
                  SocketConnection.send(CommandID.PEOPLE_WALK,0,endPos.x,endPos.y,by.length,by);
               }
            }
         }
      }
      
      public function execute_array(obj:IActionSprite, pdata:Array) : void
      {
         var p:Object = null;
         this.init();
         this._obj = obj;
         this._path = [];
         this._length = pdata.length;
         for(var i:int = 0; i < this._length; i++)
         {
            p = pdata[i];
            this._path.push(new Point(p.x,p.y));
         }
         this._endP = this._path[this._length - 1];
         this.play();
      }
      
      public function play() : void
      {
         this._isPlaying = true;
         this.nextFun();
         this._obj.sprite.addEventListener(Event.ENTER_FRAME,this.loop);
         this._obj.sprite.dispatchEvent(new RobotEvent(RobotEvent.WALK_START));
      }
      
      public function stop() : void
      {
         this._isPlaying = false;
         if(Boolean(this._obj))
         {
            this._obj.sprite.removeEventListener(Event.ENTER_FRAME,this.loop);
            this._obj.sprite.dispatchEvent(new RobotEvent(RobotEvent.WALK_END));
         }
      }
      
      public function destroy() : void
      {
         this.stop();
         this._obj = null;
         this.init();
      }
      
      public function get remData() : Array
      {
         return this._path.slice(this._currentCount);
      }
      
      public function get endP() : Point
      {
         return this._endP;
      }
      
      private function loop(e:Event) : void
      {
         if(!this._isPlaying)
         {
            return;
         }
         this._obj.pos = this._curPos;
         if(Point.distance(this._curPos,this._nextP) <= this._speed / 2)
         {
            if(this._nextNum >= this._length - 1)
            {
               if(Boolean(this._obj.sprite.parent))
               {
                  DepthManager.swapDepth(this._obj.sprite,this._obj.sprite.y);
               }
               this.stop();
               return;
            }
            this.nextFun();
         }
         this._curPos = this._curPos.add(this._disPos);
         this.setDepth();
         this._obj.sprite.dispatchEvent(new RobotEvent(RobotEvent.WALK_ENTER_FRAME));
      }
      
      private function setDepth() : void
      {
         if(this._count % 4 == 0)
         {
            if(Boolean(this._obj))
            {
               if(Boolean(this._obj.sprite.parent))
               {
                  DepthManager.swapDepth(this._obj.sprite,this._obj.sprite.y);
               }
            }
         }
         ++this._count;
      }
      
      private function nextFun() : void
      {
         var tempP:Point = null;
         this._speed = this._obj.speed;
         this._curPos = this._path[this._currentCount];
         this._nextNum = this._currentCount + 1;
         this._nextP = this._path[this._nextNum];
         var threeNum:int = this._currentCount + 2;
         if(threeNum < this._length)
         {
            tempP = this._path[threeNum];
            if(Direction.getStr(this._curPos,tempP) != this._obj.direction)
            {
               this._obj.direction = Direction.getStr(this._curPos,this._nextP);
            }
         }
         else
         {
            this._obj.direction = Direction.getStr(this._curPos,this._nextP);
         }
         this._disPos = GeomUtil.angleSpeed(this._nextP,this._curPos);
         this._disPos.x *= this._speed;
         this._disPos.y *= this._speed;
         ++this._currentCount;
      }
   }
}

