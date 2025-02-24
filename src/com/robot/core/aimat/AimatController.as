package com.robot.core.aimat
{
   import com.robot.core.config.xml.AimatXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.AimatUIManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.utils.Direction;
   import flash.display.MovieClip;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashSet;
   import org.taomee.manager.CursorManager;
   
   public class AimatController
   {
      public static var type:uint;
      
      private static var itemID:uint;
      
      private static var _instance:EventDispatcher;
      
      private static var _isAllow:Boolean = true;
      
      private static var _list:HashSet = new HashSet();
      
      public function AimatController()
      {
         super();
      }
      
      public static function addAimat(o:IAimat) : void
      {
         _list.add(o);
      }
      
      public static function removeAimat(o:IAimat) : void
      {
         _list.remove(o);
      }
      
      public static function destroy() : void
      {
         _list.each2(function(item:IAimat):void
         {
            item.destroy();
            item = null;
         });
         _list.clear();
      }
      
      public static function start(_itemID:uint) : void
      {
         if(!_isAllow)
         {
            return;
         }
         _isAllow = false;
         itemID = _itemID;
         setTimeout(function():void
         {
            _isAllow = true;
         },1000);
         dispatchEvent(AimatEvent.OPEN,new AimatInfo(type,MainManager.actorID));
         CursorManager.setCursor(UIManager.getSprite("Cursor_AimatSkin"));
         LevelManager.mapLevel.mouseChildren = false;
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
         LevelManager.mapLevel.addEventListener(MouseEvent.CLICK,onClick);
      }
      
      public static function close() : void
      {
         CursorManager.removeCursor();
         LevelManager.mapLevel.mouseChildren = true;
         LevelManager.mapLevel.removeEventListener(MouseEvent.CLICK,onClick);
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
         dispatchEvent(AimatEvent.CLOSE,new AimatInfo(type,MainManager.actorID));
      }
      
      public static function setClothType(data:Array) : void
      {
         type = AimatXMLInfo.getType(data);
      }
      
      public static function getResEffect(type:uint, annex:String = "") : MovieClip
      {
         return AimatUIManager.getMovieClip("Aimat_Effect_" + type.toString() + annex);
      }
      
      public static function getResSound(type:uint, annex:String = "") : Sound
      {
         return AimatUIManager.getSound("Aimat_Sound_" + type.toString() + annex);
      }
      
      public static function getResState(type:uint, annex:String = "") : MovieClip
      {
         return AimatUIManager.getMovieClip("Aimat_State_" + type.toString() + annex);
      }
      
      private static function onMove(e:MouseEvent) : void
      {
         MainManager.actorModel.direction = Direction.getStr(MainManager.actorModel.pos,new Point(LevelManager.stage.mouseX,LevelManager.stage.mouseY));
      }
      
      private static function onClick(e:MouseEvent) : void
      {
         close();
         MainManager.actorModel.aimatAction(itemID,type,new Point(LevelManager.mapLevel.mouseX,LevelManager.mapLevel.mouseY));
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(type:String, info:AimatInfo) : void
      {
         getInstance().dispatchEvent(new AimatEvent(type,info));
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getInstance().willTrigger(type);
      }
   }
}

