package com.robot.core.event
{
   import com.robot.core.mode.MapModel;
   import flash.events.Event;
   
   public class MapEvent extends Event
   {
      public static const MAP_SWITCH_OPEN:String = "mapSwitchOpen";
      
      public static const MAP_SWITCH_COMPLETE:String = "mapSwitchComplete";
      
      public static const MAP_EFFECT_COMPLETE:String = "mapEffectComplete";
      
      public static const MAP_LOADER_OPEN:String = "mapLoaderOpen";
      
      public static const MAP_LOADER_COMPLETE:String = "mapLoaderComplete";
      
      public static const MAP_LOADER_CLOSE:String = "mapLoaderClose";
      
      public static const MAP_INIT:String = "mapInit";
      
      public static const MAP_DESTROY:String = "mapDestroy";
      
      public static const MAP_ERROR:String = "mapError";
      
      public static const MAP_PROCESS_INIT:String = "mapProcessInit";
      
      public static const MAP_MOUSE_DOWN:String = "mapMouseDown";
      
      private var _mapModel:MapModel;
      
      public function MapEvent(type:String, mapModel:MapModel = null)
      {
         super(type,false,false);
         this._mapModel = mapModel;
      }
      
      public function get mapModel() : MapModel
      {
         return this._mapModel;
      }
   }
}

