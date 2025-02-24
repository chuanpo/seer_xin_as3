package com.robot.app.protectSys
{
   import com.robot.core.CommandID;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   
   public class ProtectSystem
   {
      private static var mc:MovieClip;
      
      private static var timer:Timer;
      
      private static var timer2:Timer;
      
      private static var leftTime:int;
      
      private static var total:uint;
      
      private static var timer_45:Timer;
      
      private static var isHoliday:Boolean = false;
      
      public static var canShow:Boolean = true;
      
      public function ProtectSystem()
      {
         super();
      }
      
      private static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.SYNC_TIME,onSyncTime);
         total = MainManager.actorInfo.timeLimit;
         leftTime = total - MainManager.actorInfo.timeToday;
         checkTime();
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,onSysTime);
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private static function onSyncTime(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         var serverTime:uint = data.readUnsignedInt();
         leftTime = total - serverTime;
         trace("serverTime:",serverTime,"game left time：",leftTime);
         checkTime();
      }
      
      public static function start(_mc:MovieClip) : void
      {
         mc = _mc;
         mc["bgMC"].gotoAndStop(1);
         setup();
      }
      
      private static function checkTime() : void
      {
         if(leftTime < 0)
         {
            leftTime = 0;
         }
         if(total - leftTime < 2 * 60 * 60)
         {
            mc["bgMC"].gotoAndStop(1);
         }
         else
         {
            mc["bgMC"].gotoAndStop(2);
         }
         if(!timer)
         {
            timer = new Timer(60 * 1000);
            timer.addEventListener(TimerEvent.TIMER,timerHandler);
         }
         if(leftTime > 60)
         {
            timer.start();
         }
         else
         {
            timer.stop();
            showSecond();
         }
         var h:String = getHours();
         var m:String = getMin();
         mc["timeTxt"].text = h + ":" + m;
         resetBar();
         trace("hours and minutes:",h,m);
         if(!timer_45)
         {
            timer_45 = new Timer(45 * 60 * 1000);
            timer_45.addEventListener(TimerEvent.TIMER,timerHandler45);
         }
         if(leftTime > 0)
         {
            timer_45.start();
         }
      }
      
      private static function timerHandler(event:TimerEvent) : void
      {
         leftTime -= 60;
         if(leftTime <= 60)
         {
            showSecond();
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,timerHandler);
            return;
         }
         resetBar();
         var h:String = getHours();
         var m:String = getMin();
         mc["timeTxt"].text = h + ":" + m;
      }
      
      private static function resetBar() : void
      {
         var num:uint = Math.ceil(4 * (leftTime / total));
         for(var i:uint = 0; i < 4; i++)
         {
            mc["bar_" + i].visible = false;
         }
         for(i = 0; i < num; i++)
         {
            mc["bar_" + i].visible = true;
         }
      }
      
      private static function showSecond() : void
      {
         if(!timer2)
         {
            timer2 = new Timer(1000);
            timer2.addEventListener(TimerEvent.TIMER,secondTimerHandler);
            timer2.start();
         }
      }
      
      private static function secondTimerHandler(event:TimerEvent) : void
      {
         --leftTime;
         var s:String = leftTime.toString();
         if(s.length < 2)
         {
            s = "0" + s;
         }
         if(leftTime < 0)
         {
            mc["timeTxt"].text = "00:00";
         }
         else
         {
            mc["timeTxt"].text = "00:" + s;
         }
         if(leftTime <= 0)
         {
            mc["bgMC"].gotoAndStop(2);
            mc["timeTxt"].text = "00:00";
            Alarm.show("精灵包电量耗尽，所有精灵进入休眠状态。明天电量就可以恢复，你就可以重新训练精灵了");
            timer2.stop();
            timer2.removeEventListener(TimerEvent.TIMER,secondTimerHandler);
            SocketConnection.removeCmdListener(CommandID.SYNC_TIME,onSyncTime);
         }
      }
      
      private static function getHours() : String
      {
         var h:String = Math.floor(leftTime / 60 / 60).toString();
         if(h.length < 2)
         {
            h = "0" + h;
         }
         return h;
      }
      
      private static function getMin() : String
      {
         var h:uint = uint(getHours()) * 60 * 60;
         var time:uint = uint(leftTime - h);
         var num:uint = Math.ceil(time / 60);
         if(num == 60)
         {
            num = 59;
         }
         var m:String = num.toString();
         if(m.length < 2)
         {
            m = "0" + m;
         }
         return m;
      }
      
      private static function onSysTime(event:SocketEvent) : void
      {
         var date:Date = (event.data as SystemTimeInfo).date;
         trace(date.getDay());
         isHoliday = date.getDay() > 4 || date.getDay() == 0;
         if(!isHoliday)
         {
            mc["bgMC"].gotoAndStop(2);
         }
         else if(total - leftTime < 2 * 60 * 60)
         {
            mc["bgMC"].gotoAndStop(1);
         }
         else
         {
            mc["bgMC"].gotoAndStop(2);
         }
      }
      
      private static function timerHandler45(event:TimerEvent) : void
      {
         if(canShow)
         {
            MaskScreen.show();
         }
      }
   }
}

import com.robot.core.manager.LevelManager;
import flash.display.MovieClip;
import flash.events.TimerEvent;
import flash.utils.Timer;
import org.taomee.utils.DisplayUtil;

class MaskScreen
{
   private static var mc:MovieClip;
   
   private static var timer:Timer;
   
   public function MaskScreen()
   {
      super();
   }
   
   public static function show() : void
   {
      if(!mc)
      {
         mc = new lib_fullScreen_mc();
         timer = new Timer(1000,60);
         timer.addEventListener(TimerEvent.TIMER,onTimer);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerComp);
      }
      LevelManager.topLevel.addChild(mc);
      timer.reset();
      timer.start();
   }
   
   private static function onTimer(e:TimerEvent) : void
   {
      mc["txt"].text = (60 - timer.currentCount).toString();
   }
   
   private static function onTimerComp(e:TimerEvent) : void
   {
      DisplayUtil.removeForParent(mc);
   }
}
