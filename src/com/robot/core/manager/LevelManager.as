package com.robot.core.manager
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.ScrollMapEvent;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.geom.Point;
   import gs.TweenLite;
   import org.taomee.manager.EventManager;
   
   public class LevelManager
   {
      private static var _root:Sprite;
      
      private static var _gameLevel:Sprite;
      
      private static var _topLevel:Sprite;
      
      private static var _appLevel:Sprite;
      
      private static var _toolsLevel:Sprite;
      
      private static var _mapLevel:Sprite;
      
      private static var _iconLevel:Sprite;
      
      private static var _fightLevel:Sprite;
      
      private static var _tipLevel:Sprite;
      
      public static var isRecordMapPos:Boolean = false;
      
      private static var isTween:Boolean = false;
      
      private static const CHECK:uint = 150;
      
      private static const DIS:uint = 700;
      
      public function LevelManager()
      {
         super();
      }
      
      public static function setup(con:Sprite) : void
      {
         _root = con;
         _mapLevel = new Sprite();
         _mapLevel.name = "mapLevel";
         _root.addChild(_mapLevel);
         _toolsLevel = new Sprite();
         _toolsLevel.name = "toolsLevel";
         _root.addChild(_toolsLevel);
         _iconLevel = new Sprite();
         _iconLevel.name = "iconLevel";
         _root.addChild(_iconLevel);
         _appLevel = new Sprite();
         _appLevel.name = "appLevel";
         _root.addChild(_appLevel);
         _topLevel = new Sprite();
         _topLevel.name = "topLevel";
         _root.addChild(_topLevel);
         _tipLevel = new Sprite();
         _tipLevel.name = "tipLevel";
         _root.addChild(_tipLevel);
         _gameLevel = new Sprite();
         _gameLevel.name = "gameLevel";
         _root.addChild(_gameLevel);
         _fightLevel = new Sprite();
         _fightLevel.name = "fightLevel";
         _root.addChild(_fightLevel);
      }
      
      public static function get root() : Sprite
      {
         return _root;
      }
      
      public static function get stage() : Stage
      {
         return _root.stage;
      }
      
      public static function get mapLevel() : Sprite
      {
         return _mapLevel;
      }
      
      public static function get toolsLevel() : Sprite
      {
         return _toolsLevel;
      }
      
      public static function get appLevel() : Sprite
      {
         return _appLevel;
      }
      
      public static function get topLevel() : Sprite
      {
         return _topLevel;
      }
      
      public static function get gameLevel() : Sprite
      {
         return _gameLevel;
      }
      
      public static function get iconLevel() : Sprite
      {
         return _iconLevel;
      }
      
      public static function get tipLevel() : Sprite
      {
         return _tipLevel;
      }
      
      public static function get fightLevel() : Sprite
      {
         return _fightLevel;
      }
      
      public static function openMouseEvent() : void
      {
         _mapLevel.mouseEnabled = true;
         _mapLevel.mouseChildren = true;
         _toolsLevel.mouseEnabled = true;
         _toolsLevel.mouseChildren = true;
         _appLevel.mouseEnabled = true;
         _appLevel.mouseChildren = true;
         _iconLevel.mouseEnabled = true;
         _iconLevel.mouseChildren = true;
      }
      
      public static function closeMouseEvent() : void
      {
         _mapLevel.mouseEnabled = false;
         _mapLevel.mouseChildren = false;
         _toolsLevel.mouseEnabled = false;
         _toolsLevel.mouseChildren = false;
         _iconLevel.mouseEnabled = false;
         _iconLevel.mouseChildren = false;
      }
      
      public static function showMapLevel() : void
      {
         _mapLevel.y = 0;
      }
      
      public static function hideMapLevel() : void
      {
         _mapLevel.y = 600;
      }
      
      public static function hideAll(... args) : void
      {
         var i:Sprite = null;
         for each(i in args)
         {
            i.y = 600;
         }
      }
      
      public static function showAll(... args) : void
      {
         var i:Sprite = null;
         for each(i in args)
         {
            i.y = 0;
         }
      }
      
      public static function set mapScroll(b:Boolean) : void
      {
         if(b)
         {
            open();
         }
         else
         {
            close();
         }
      }
      
      private static function open() : void
      {
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,onWalk);
      }
      
      private static function close() : void
      {
         if(isRecordMapPos)
         {
            isRecordMapPos = false;
         }
         else
         {
            LevelManager.mapLevel.x = 0;
         }
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,onWalk);
      }
      
      private static function onWalk(event:RobotEvent) : void
      {
         var oldx:Number = NaN;
         var t:Number = NaN;
         if(isTween)
         {
            return;
         }
         var p:Point = MainManager.actorModel.localToGlobal(new Point());
         if(p.x > MainManager.getStageWidth() - CHECK)
         {
            oldx = LevelManager.mapLevel.x;
            t = MainManager.getStageWidth() - LevelManager.mapLevel.x + DIS;
            if(t > MapManager.currentMap.width)
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":MainManager.getStageWidth() - MapManager.currentMap.width,
                  "onComplete":onComp
               });
            }
            else
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":oldx - DIS,
                  "onComplete":onComp
               });
            }
         }
         else if(p.x < CHECK)
         {
            oldx = LevelManager.mapLevel.x;
            t = LevelManager.mapLevel.x + DIS;
            if(t > 0)
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":0,
                  "onComplete":onComp
               });
            }
            else
            {
               isTween = true;
               TweenLite.to(LevelManager.mapLevel,1,{
                  "x":oldx + DIS,
                  "onComplete":onComp
               });
            }
         }
      }
      
      private static function onComp() : void
      {
         isTween = false;
         EventManager.dispatchEvent(new ScrollMapEvent(ScrollMapEvent.SCROLL_COMPLETE));
      }
      
      public static function moveToRight() : void
      {
         LevelManager.mapLevel.x = MainManager.getStageWidth() - MapManager.currentMap.width;
      }
      
      public static function moveToLeft() : void
      {
         LevelManager.mapLevel.x = 0;
      }
   }
}

