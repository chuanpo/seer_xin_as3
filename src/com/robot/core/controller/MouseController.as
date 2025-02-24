package com.robot.core.controller
{
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.map.config.MapConfig;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import org.taomee.utils.MovieClipUtil;
   
   public class MouseController
   {
      private static var _mouseTxt:TextField;
      
      public static var CanMove:Boolean = true;
      
      public function MouseController()
      {
         super();
      }
      
      public static function addMouseEvent() : void
      {
         MapManager.currentMap.spaceLevel.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      public static function removeMouseEvent() : void
      {
         MapManager.currentMap.spaceLevel.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMouseMove);
      }
      
      private static function showMouseXY() : void
      {
         if(_mouseTxt == null)
         {
            _mouseTxt = new TextField();
            _mouseTxt.autoSize = TextFieldAutoSize.LEFT;
            _mouseTxt.mouseEnabled = false;
            LevelManager.stage.addChild(_mouseTxt);
         }
      }
      
      private static function upDateTxt() : void
      {
         var _x:int = LevelManager.stage.mouseX;
         var _y:int = LevelManager.stage.mouseY;
         _mouseTxt.x = _x + 15;
         _mouseTxt.y = _y + 5;
         _mouseTxt.text = MainManager.actorInfo.mapID.toString() + " / " + _x.toString() + "," + _y.toString();
      }
      
      private static function onMouseDown(e:MouseEvent) : void
      {
         var mui:MovieClip = null;
         var dp:Point = new Point(e.currentTarget.mouseX,e.currentTarget.mouseY);
         MapConfig.delEnterFrame();
         MainManager.actorModel.walkAction(dp);
         LevelManager.stage.focus = LevelManager.stage;
         MapManager.dispatchEvent(new MapEvent(MapEvent.MAP_MOUSE_DOWN,MapManager.currentMap));
         mui = UIManager.getMovieClip("Effect_MouseDown");
         mui.mouseEnabled = false;
         mui.mouseChildren = false;
         MovieClipUtil.playEndAndRemove(mui);
         mui.x = dp.x;
         mui.y = dp.y;
         LevelManager.mapLevel.addChild(mui);
      }
      
      private static function onMouseMove(e:MouseEvent) : void
      {
         e.updateAfterEvent();
      }
   }
}

