package org.taomee.utils
{
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   
   public class SOFlushPool
   {
      private static const TIME:int = 100;
      
      private var _poolList:Array;
      
      private var _time:Timer;
      
      public function SOFlushPool()
      {
         super();
         _poolList = new Array();
         _time = new Timer(TIME,0);
         _time.addEventListener(TimerEvent.TIMER,onTime);
      }
      
      private function onTime(e:TimerEvent) : void
      {
         var shareObject:SharedObject = _poolList.shift();
         if(shareObject != null)
         {
            try
            {
               shareObject.flush();
            }
            catch(e:Error)
            {
               trace("SOFlushPool.flush",e.toString());
            }
         }
         else
         {
            _time.stop();
         }
      }
      
      public function addFlush(so:SharedObject) : void
      {
         if(!isInPool(so))
         {
            _poolList.push(so);
            if(!_time.running)
            {
               _time.reset();
               _time.start();
            }
         }
      }
      
      private function isInPool(so:SharedObject) : Boolean
      {
         return _poolList.indexOf(so) != -1;
      }
   }
}

