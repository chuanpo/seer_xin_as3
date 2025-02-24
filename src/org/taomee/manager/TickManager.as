package org.taomee.manager
{
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import org.taomee.ds.HashSet;
   
   public class TickManager
   {
      private static var _running:Boolean;
      
      private static var _hashSet:HashSet = new HashSet();
      
      private static var _interval:Number = 40;
      
      private static var _id:uint = 0;
      
      public function TickManager()
      {
         super();
      }
      
      private static function onTick() : void
      {
         _hashSet.each2(function(func:Function):void
         {
            func();
         });
      }
      
      public static function get interval() : Number
      {
         return _interval;
      }
      
      public static function getFrameForTime(t:Number) : Number
      {
         return t / _interval;
      }
      
      public static function stop() : void
      {
         if(_running)
         {
            clearInterval(_id);
            _running = false;
         }
      }
      
      public static function set interval(time:Number) : void
      {
         _interval = time;
         clearInterval(_id);
         _running = false;
         setup();
      }
      
      public static function getTimeForFrame(f:Number) : Number
      {
         return f * _interval;
      }
      
      public static function hasListener(listener:Function) : Boolean
      {
         return _hashSet.contains(listener);
      }
      
      public static function removeListener(listener:Function) : void
      {
         _hashSet.remove(listener);
      }
      
      public static function play() : void
      {
         if(!_running)
         {
            setup();
         }
      }
      
      public static function addListener(listener:Function) : void
      {
         _hashSet.add(listener);
      }
      
      public static function setup() : void
      {
         _id = setInterval(onTick,_interval);
         _running = true;
      }
      
      public static function get running() : Boolean
      {
         return _running;
      }
   }
}

