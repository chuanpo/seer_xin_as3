package org.taomee.utils
{
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class TimerUtil
   {
      public function TimerUtil()
      {
         super();
      }
      
      public static function clearAllTimer() : void
      {
         clearAllTimeout();
         clearAllInterval();
      }
      
      private static function getTimerInstance(closure:Function, delay:Number, num:uint, vars:*) : Timer
      {
         var tempTimer:Timer = null;
         tempTimer = new Timer(delay,num);
         tempTimer.addEventListener(TimerEvent.TIMER,function(E:TimerEvent):void
         {
            if(E.currentTarget.currentCount == E.currentTarget.repeatCount)
            {
               tempTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,arguments.callee);
               clearGTimeout(tempTimer);
            }
            if(vars.length > 0)
            {
               closure.apply(this,vars);
            }
            else
            {
               closure();
            }
         });
         tempTimer.start();
         return tempTimer;
      }
      
      public static function clearGTimeout(timer:Timer) : void
      {
         if(Boolean(timer))
         {
            timer.stop();
            timer = null;
         }
      }
      
      public static function clearAllInterval() : void
      {
         var timeoutNum:uint = 0;
         timeoutNum = setInterval(function():void
         {
            var i:*;
            timeoutNum = setInterval(function():void
            {
            },0);
            for(i = 1; i <= timeoutNum; i++)
            {
               clearInterval(i);
            }
         },0);
      }
      
      public static function setGInterval(closure:Function, delay:*, ... vars) : Timer
      {
         var num:uint = 0;
         var ta:Array = null;
         if(Boolean(delay as String) && delay.indexOf(":") > -1)
         {
            ta = delay.split(":");
            num = uint(int(ta[1]));
            delay = int(ta[0]);
         }
         else
         {
            num = 0;
         }
         return getTimerInstance(closure,delay,num,vars);
      }
      
      public static function setGTimeout(closure:Function, delay:Number, ... vars) : Timer
      {
         return getTimerInstance(closure,delay,1,vars);
      }
      
      public static function clearAllTimeout() : void
      {
         var timeoutNum:uint = 0;
         timeoutNum = setTimeout(function():void
         {
            var i:*;
            timeoutNum = setTimeout(function():void
            {
            },0);
            for(i = 1; i <= timeoutNum; i++)
            {
               clearTimeout(i);
            }
         },0);
      }
      
      public static function clearGInterval(timer:Timer) : void
      {
         if(Boolean(timer))
         {
            timer.stop();
            timer = null;
         }
      }
   }
}

