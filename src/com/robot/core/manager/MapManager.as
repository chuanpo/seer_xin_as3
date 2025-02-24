package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.controller.MapController;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.mode.MapModel;
   import com.robot.core.net.ConnectionType;
   import com.robot.core.net.SocketConnection;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.utils.getDefinitionByName;
   import org.taomee.manager.EventManager;
   
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="mapInit",type="com.robot.core.event.MapEvent")]
   [Event(name="mapLoaderComplete",type="com.robot.core.event.MapEvent")]
   [Event(name="mapLoaderClose",type="com.robot.core.event.MapEvent")]
   [Event(name="mapLoaderOpen",type="com.robot.core.event.MapEvent")]
   [Event(name="mapSwitchComplete",type="com.robot.core.event.MapEvent")]
   [Event(name="mapSwitchOpen",type="com.robot.core.event.MapEvent")]
   [Event(name="mapMouseDown",type="com.robot.core.event.MapEvent")]
   public class MapManager
   {
      public static var currentMap:MapModel;
      
      public static var styleID:uint;
      
      public static var initPos:Point;
      
      public static var prevMapID:uint;
      
      public static var isInMap:Boolean;
      
      private static var _mapType:uint;
      
      private static var _mapController:MapController;
      
      private static var instance:EventDispatcher;
      
      public static const FRESH_TRIALS:uint = 600;
      
      public static const TOWER_MAP:uint = 500;
      
      public static const ID_MAX:uint = 10000;
      
      public static const TYPE_MAX:uint = 200;
      
      public static const defaultID:uint = 1;
      
      public static const defaultRoomStyleID:uint = 500001;
      
      public static const defaultArmStyleID:uint = 800001;
      
      public static var type:int = ConnectionType.MAIN;
      
      public static var DESTROY_SWITCH:Boolean = true;
      
      setup();
      
      public function MapManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         getMapController();
         EventManager.addEventListener(PetFightEvent.ALARM_CLICK,onFightClose);
      }
      
      private static function onFightClose(event:PetFightEvent) : void
      {
         if(!DESTROY_SWITCH)
         {
            SocketConnection.send(CommandID.LIST_MAP_PLAYER);
         }
      }
      
      public static function getMapController() : MapController
      {
         if(_mapController == null)
         {
            _mapController = new MapController();
         }
         return _mapController;
      }
      
      public static function getResMapID(mapID:uint) : uint
      {
         if(mapID > MapManager.ID_MAX)
         {
            return styleID;
         }
         return mapID;
      }
      
      public static function changeMap(mapID:int, dir:int = 0, mapType:uint = 0) : void
      {
         var cls:* = getDefinitionByName("com.robot.app.task.noviceGuide.CheckGuideTaskStatus");
         if(Boolean(cls.check(mapID)))
         {
            _mapType = mapType;
            getMapController().changeMap(mapID,dir,mapType);
         }
      }
      
      public static function changeLocalMap(mapID:uint) : void
      {
         getMapController().changeLocalMap(mapID);
      }
      
      public static function refMap(isShowLoading:Boolean = true) : void
      {
         if(DESTROY_SWITCH)
         {
            getMapController().refMap(isShowLoading);
         }
      }
      
      public static function destroy() : void
      {
         if(DESTROY_SWITCH)
         {
            getMapController().destroy();
         }
      }
      
      public static function getObjectsPointRect(p:Point, r:Number = 10, types:Array = null) : Array
      {
         var arr:Array = null;
         var obj:DisplayObject = null;
         var t:Class = null;
         if(!isInMap)
         {
            return arr;
         }
         var con:DisplayObjectContainer = currentMap.depthLevel;
         var num:int = con.numChildren;
         arr = [];
         for(var i:int = 0; i < num; i++)
         {
            obj = con.getChildAt(i);
            if(types == null)
            {
               if(Point.distance(new Point(obj.x,obj.y),p) < r)
               {
                  arr.push(obj);
               }
            }
            else
            {
               for each(t in types)
               {
                  if(obj is t)
                  {
                     if(Point.distance(new Point(obj.x,obj.y),p) < r)
                     {
                        arr.push(obj);
                     }
                     break;
                  }
               }
            }
         }
         return arr;
      }
      
      public static function getObjectPoint(p:Point, types:Array = null) : DisplayObject
      {
         var obj:DisplayObject = null;
         var t:Class = null;
         if(!isInMap)
         {
            return null;
         }
         var con:DisplayObjectContainer = currentMap.depthLevel;
         var num:int = con.numChildren - 1;
         for(var i:int = num; i >= 0; i--)
         {
            obj = con.getChildAt(i);
            if(types == null)
            {
               if(obj.hitTestPoint(p.x,p.y))
               {
                  return obj;
               }
            }
            else
            {
               for each(t in types)
               {
                  if(obj is t)
                  {
                     if(obj.hitTestPoint(p.x,p.y))
                     {
                        return obj;
                     }
                     break;
                  }
               }
            }
         }
         return null;
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         if(hasEventListener(event.type))
         {
            getInstance().dispatchEvent(event);
         }
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

