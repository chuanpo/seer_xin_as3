package com.robot.app.control
{
   import com.robot.app.task.taskUtils.taskDialog.DynamicNpcTipDialog;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import flash.events.Event;
   
   public class FollowController
   {
      public function FollowController()
      {
         super();
      }
      
      public static function followSuperNono(withoutNonoStr:String, noSuperStr:String, func:Function = null, superFunc:Function = null) : void
      {
         var info:NonoInfo = null;
         if(Boolean(MainManager.actorModel.nono))
         {
            if(func != null)
            {
               func();
            }
            info = NonoManager.info;
            if(info.superNono)
            {
               if(superFunc != null)
               {
                  superFunc();
               }
            }
            else
            {
               DynamicNpcTipDialog.show(noSuperStr,function():void
               {
                  var r:VipSession = new VipSession();
                  r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
                  {
                  });
                  r.getSession();
               },NpcTipDialog.NONO);
            }
         }
         else
         {
            NpcTipDialog.show(withoutNonoStr,null,NpcTipDialog.NONO);
         }
      }
      
      public static function followPet(noPetFunc:Function = null, petFunc:Function = null, petIDArr:Array = null, petType:String = null, petIsTypeFunc:Function = null, petNoTypeFunc:Function = null) : void
      {
         var petID:uint = 0;
         var id:uint = 0;
         if(Boolean(MainManager.actorModel.pet))
         {
            petID = uint(MainManager.actorModel.pet.info.petID);
            if(petIDArr == null && petType == null && petType == "")
            {
               if(petFunc != null)
               {
                  petFunc();
               }
            }
            else if(petIDArr != null)
            {
               for each(id in petIDArr)
               {
                  if(id == petID)
                  {
                     if(petIsTypeFunc != null)
                     {
                        petIsTypeFunc();
                     }
                     return;
                  }
               }
               if(petNoTypeFunc != null)
               {
                  petNoTypeFunc();
               }
            }
            else
            {
               if(petType == null || petType == "")
               {
                  return;
               }
               if(PetXMLInfo.getTypeCN(petID) == petType)
               {
                  if(petIsTypeFunc != null)
                  {
                     petIsTypeFunc();
                  }
               }
               else if(petNoTypeFunc != null)
               {
                  petNoTypeFunc();
               }
            }
         }
         else if(noPetFunc != null)
         {
            noPetFunc();
         }
      }
   }
}

