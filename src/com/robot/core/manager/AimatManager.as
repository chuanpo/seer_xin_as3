package com.robot.core.manager
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import flash.display.DisplayObject;
   
   public class AimatManager
   {
      public function AimatManager()
      {
         super();
      }
      
      public static function useHeadShoot(headItemID:uint, func:Function = null, isHit:Boolean = false, disArr:Array = null, hitFun:Function = null, noHitFun:Function = null) : void
      {
         AimatController.addEventListener(AimatEvent.PLAY_END,function(evt:AimatEvent):void
         {
            var dis:DisplayObject = null;
            AimatController.removeEventListener(AimatEvent.PLAY_END,arguments.callee);
            var info:AimatInfo = evt.info;
            if(info.userID != MainManager.actorID)
            {
               return;
            }
            if(isHit)
            {
               if(Boolean(disArr))
               {
                  for each(dis in disArr)
                  {
                     if(Boolean(dis))
                     {
                        if(dis.hitTestPoint(info.endPos.x,info.endPos.y))
                        {
                           if(hitFun != null)
                           {
                              hitFun();
                              return;
                           }
                        }
                     }
                  }
                  if(noHitFun != null)
                  {
                     noHitFun();
                  }
               }
            }
            else if(func != null)
            {
               func();
            }
         });
      }
   }
}

