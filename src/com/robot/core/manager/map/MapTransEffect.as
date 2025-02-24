package com.robot.core.manager.map
{
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.MapModel;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import gs.TweenMax;
   import gs.easing.Sine;
   import gs.events.TweenEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapTransEffect extends EventDispatcher
   {
      public static const NONE:int = 0;
      
      public static const TOP:int = 1;
      
      public static const LEFT:int = 2;
      
      public static const DOWN:int = 3;
      
      public static const RIGHT:int = 4;
      
      private var _mapModel:MapModel;
      
      private var _dir:int = 0;
      
      private var _sprite:Sprite;
      
      public function MapTransEffect(mm:MapModel, dir:int)
      {
         super();
         this._mapModel = mm;
         this._dir = dir;
      }
      
      public function star() : void
      {
         var p:Point = null;
         var bd:BitmapData = null;
         var bmp:Bitmap = null;
         var bd2:BitmapData = null;
         var bmp2:Bitmap = null;
         if(this._dir == 0)
         {
            dispatchEvent(new MapEvent(MapEvent.MAP_EFFECT_COMPLETE));
         }
         else
         {
            p = this.getNewMapXY();
            this._sprite = new Sprite();
            bd = new BitmapData(MainManager.getStageWidth(),MainManager.getStageHeight());
            bmp = new Bitmap(bd);
            bd.draw(LevelManager.mapLevel.getChildAt(0));
            this._sprite.addChild(bmp);
            bd2 = new BitmapData(MainManager.getStageWidth(),MainManager.getStageHeight());
            bmp2 = new Bitmap(bd2);
            bmp2.x = p.x;
            bmp2.y = p.y;
            bd2.draw(this._mapModel.root);
            this._sprite.addChild(bmp2);
            DisplayUtil.removeAllChild(LevelManager.mapLevel);
            LevelManager.mapLevel.addChild(this._sprite);
            this.moveMap(this._sprite,p);
         }
      }
      
      private function moveMap(sprite:DisplayObject, p:Point) : void
      {
         var finishx:Number = NaN;
         var finishy:Number = NaN;
         var myTween:TweenMax = null;
         if(p.x == 0)
         {
            finishx = 0;
            finishy = -p.y;
         }
         else if(p.y == 0)
         {
            finishx = -p.x;
            finishy = 0;
         }
         myTween = new TweenMax(sprite,1,{
            "x":finishx,
            "y":finishy,
            "ease":Sine.easeOut
         });
         myTween.addEventListener(TweenEvent.COMPLETE,function(event:TweenEvent):void
         {
            myTween.removeEventListener(TweenEvent.COMPLETE,arguments.callee);
            _mapModel.root.addEventListener(Event.ADDED_TO_STAGE,onAddHandler);
            dispatchEvent(new MapEvent(MapEvent.MAP_EFFECT_COMPLETE));
         });
      }
      
      private function onAddHandler(e:Event) : void
      {
         this._mapModel.root.removeEventListener(Event.ADDED_TO_STAGE,this.onAddHandler);
         DisplayUtil.removeForParent(this._sprite);
         this._sprite = null;
         this._mapModel = null;
      }
      
      private function getNewMapXY() : Point
      {
         var p:Point = null;
         switch(this._dir)
         {
            case TOP:
               p = new Point(0,-MainManager.getStageHeight());
               break;
            case LEFT:
               p = new Point(-MainManager.getStageWidth(),0);
               break;
            case DOWN:
               p = new Point(0,MainManager.getStageHeight());
               break;
            case RIGHT:
               p = new Point(MainManager.getStageWidth(),0);
               break;
            default:
               p = new Point(0,-MainManager.getStageHeight());
         }
         return p;
      }
   }
}

