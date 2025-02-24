package com.robot.core.mode
{
   import com.robot.core.mode.spriteModelAdditive.ISpriteModelAdditive;
   import com.robot.core.mode.spriteModelAdditive.PeopleBloodBar;
   import com.robot.core.mode.spriteModelAdditive.SpriteFreeze;
   import com.robot.core.utils.Direction;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SpriteModel extends Sprite implements ISprite
   {
      protected var _direction:String = Direction.DOWN;
      
      protected var _pos:Point = new Point();
      
      protected var _centerPoint:Point = new Point();
      
      protected var _hitRect:Rectangle = new Rectangle();
      
      private var additiveList:Array = [];
      
      private var _bloodBar:PeopleBloodBar;
      
      public function SpriteModel()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function set pos(p:Point) : void
      {
         this._pos.x = p.x;
         this._pos.y = p.y;
         this.x = p.x;
         this.y = p.y;
      }
      
      public function get pos() : Point
      {
         this._pos.x = x;
         this._pos.y = y;
         return this._pos;
      }
      
      override public function set x(v:Number) : void
      {
         super.x = v;
         this._pos.x = v;
      }
      
      override public function set y(v:Number) : void
      {
         super.y = v;
         this._pos.y = v;
      }
      
      public function get sprite() : Sprite
      {
         return this;
      }
      
      public function set direction(dir:String) : void
      {
         if(dir == null || dir == "")
         {
            return;
         }
         this._direction = dir;
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function get centerPoint() : Point
      {
         this._centerPoint.x = x;
         this._centerPoint.y = y;
         return this._centerPoint;
      }
      
      public function get hitRect() : Rectangle
      {
         this._hitRect.x = x;
         this._hitRect.y = y;
         this._hitRect.width = width;
         this._hitRect.height = height;
         return this._hitRect;
      }
      
      public function set additive(array:Array) : void
      {
         var i:ISpriteModelAdditive = null;
         this.removeAllAditive();
         this.additiveList = array.slice();
         try
         {
            for each(i in this.additiveList)
            {
               i.model = this;
               i.init();
               i.show();
            }
         }
         catch(e:TypeError)
         {
            throw new Error("可视对象附加功能必须实现ISpriteModelAdditive接口！");
         }
      }
      
      public function showAllAdditive() : void
      {
         var i:ISpriteModelAdditive = null;
         for each(i in this.additiveList)
         {
            i.show();
         }
      }
      
      public function hideAllAdditive() : void
      {
         var i:ISpriteModelAdditive = null;
         for each(i in this.additiveList)
         {
            i.hide();
         }
      }
      
      public function appendAdditive(i:ISpriteModelAdditive) : void
      {
         this.additiveList.push(i);
         i.init();
      }
      
      public function removeAdditive(i:ISpriteModelAdditive) : void
      {
         var index:int = int(this.additiveList.indexOf(i));
         if(index != -1)
         {
            i.destroy();
            this.additiveList.splice(index,1);
         }
      }
      
      public function removeAllAditive(isAll:Boolean = false) : void
      {
         var i:ISpriteModelAdditive = null;
         for each(i in this.additiveList)
         {
            if(!isAll)
            {
               if(!(i is SpriteFreeze))
               {
                  i.destroy();
               }
            }
            else
            {
               i.destroy();
            }
         }
         this.additiveList = [];
      }
      
      public function addPos(p:Point) : void
      {
         this._pos = this._pos.add(p);
         this.x = this._pos.x;
         this.y = this._pos.y;
      }
      
      public function subtractPos(p:Point) : void
      {
         this._pos = this._pos.subtract(p);
         this.x = this._pos.x;
         this.y = this._pos.y;
      }
      
      public function destroy() : void
      {
         this.removeAllAditive();
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      public function removeBloodBar() : void
      {
         DisplayUtil.removeForParent(this._bloodBar);
         if(Boolean(this._bloodBar))
         {
            this._bloodBar.destroy();
         }
         this._bloodBar = null;
      }
      
      public function get bloodBar() : PeopleBloodBar
      {
         if(!this._bloodBar)
         {
            this._bloodBar = new PeopleBloodBar();
            this._bloodBar.model = this;
            this._bloodBar.y = 30;
            this.addChild(this._bloodBar);
         }
         return this._bloodBar;
      }
      
      private function onAddedToStage(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         DepthManager.swapDepth(this,y);
      }
   }
}

