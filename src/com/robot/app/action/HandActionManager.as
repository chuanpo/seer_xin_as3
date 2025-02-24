package com.robot.app.action
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.Direction;
   import flash.display.Sprite;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   
   public class HandActionManager
   {
      private static var waitTimer:Timer;
      
      private static var overFunc:Function;
      
      private static var walkFunc:Function;
      
      public function HandActionManager()
      {
         super();
      }
      
      public static function onHeadAction(itemID:uint, haoNoToolFunc:Function = null, waitTime:uint = 10000, overFun:Function = null, walkFun:Function = null, bDir:Boolean = true) : void
      {
         overFunc = overFun;
         walkFunc = walkFun;
         if(MainManager.actorInfo.clothIDs.indexOf(itemID) == -1 && MainManager.actorInfo.clothIDs.indexOf(100717) == -1)
         {
            if(haoNoToolFunc != null)
            {
               haoNoToolFunc();
            }
            else
            {
               Alarm.show("你没有相应的工具噢,装备好了它再来吧!");
            }
            return;
         }
         if(!bDir)
         {
            MainManager.actorModel.skeleton.getSkeletonMC().scaleX = -1;
         }
         if(MainManager.actorInfo.clothIDs.indexOf(itemID) == -1)
         {
            MainManager.actorModel.specialAction(100717);
         }
         else
         {
            MainManager.actorModel.specialAction(itemID);
         }
         var sprite:Sprite = MainManager.actorModel.sprite;
         sprite.parent.addChild(sprite);
         if(waitTimer != null)
         {
            waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
            waitTimer = null;
         }
         waitTimer = new Timer(waitTime,1);
         waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
         waitTimer.start();
         MainManager.actorModel.sprite.addEventListener(RobotEvent.WALK_START,onWalk);
      }
      
      private static function onTimeOver(evt:TimerEvent) : void
      {
         waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,onWalk);
         MainManager.actorModel.stopSpecialAct();
         MainManager.actorModel.skeleton.getSkeletonMC().scaleX = 1;
         if(overFunc != null)
         {
            overFunc();
         }
      }
      
      private static function onWalk(evt:RobotEvent) : void
      {
         waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimeOver);
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,onWalk);
         waitTimer.stop();
         MainManager.actorModel.stop();
         MainManager.actorModel.stopSpecialAct();
         MainManager.actorModel.direction = Direction.DOWN;
         MainManager.actorModel.skeleton.getSkeletonMC().scaleX = 1;
         if(walkFunc != null)
         {
            walkFunc();
         }
         else
         {
            Alarm.show("不能随便走动噢");
         }
      }
   }
}

