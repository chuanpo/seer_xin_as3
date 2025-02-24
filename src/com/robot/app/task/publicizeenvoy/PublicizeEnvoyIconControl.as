package com.robot.app.task.publicizeenvoy
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TaskIconManager;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.BitUtil;
   
   public class PublicizeEnvoyIconControl
   {
      private static var _iconMc:MovieClip;
      
      private static var _lightMC:MovieClip;
      
      private static var _isAlarm:Boolean = false;
      
      public function PublicizeEnvoyIconControl()
      {
         super();
      }
      
      public static function canGetTaskReword(count:uint, reword:uint) : Boolean
      {
         var _firstAccept:Boolean = Boolean(BitUtil.getBit(reword,0));
         var _secondAccept:Boolean = Boolean(BitUtil.getBit(reword,1));
         var _thirdAccept:Boolean = Boolean(BitUtil.getBit(reword,2));
         if(count >= 2 && count <= 5)
         {
            if(!_firstAccept)
            {
               return true;
            }
         }
         else if(count >= 5 && count <= 10)
         {
            if(!_firstAccept || !_secondAccept)
            {
               return true;
            }
         }
         else if(count >= 10)
         {
            if(!_firstAccept || !_secondAccept || !_thirdAccept)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function check() : void
      {
         var b:Boolean = false;
         var count:uint = uint(MainManager.actorInfo.newInviteeCnt);
         var reword:uint = uint(MainManager.actorInfo.freshManBonus);
         var _firstAccept:Boolean = Boolean(BitUtil.getBit(reword,1));
         var _secondAccept:Boolean = Boolean(BitUtil.getBit(reword,2));
         var _thirdAccept:Boolean = Boolean(BitUtil.getBit(reword,3));
         if(MainManager.actorInfo.dsFlag == 1)
         {
            if(_firstAccept && _secondAccept && _thirdAccept)
            {
               return;
            }
            addIcon();
            b = canGetTaskReword(count,reword);
            if(b)
            {
               lightIcon();
            }
         }
      }
      
      public static function addIcon() : void
      {
         _iconMc = TaskIconManager.getIcon("PublicizeEnloy_ICON") as MovieClip;
         ToolTipManager.add(_iconMc,"赛尔召集令");
         TaskIconManager.addIcon(_iconMc);
         _lightMC = _iconMc["lightMC"];
         _lightMC.visible = false;
         _iconMc.buttonMode = true;
         _iconMc.visible = false;
         _iconMc.addEventListener(MouseEvent.CLICK,onClickHandler);
      }
      
      private static function onClickHandler(e:MouseEvent) : void
      {
         PublicizeEnvoyController.show(_isAlarm);
         _isAlarm = false;
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(_iconMc);
      }
      
      public static function lightIcon() : void
      {
         if(Boolean(_lightMC))
         {
            _lightMC.visible = true;
            _isAlarm = true;
         }
      }
   }
}

