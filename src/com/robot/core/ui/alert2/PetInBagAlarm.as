package com.robot.core.ui.alert2
{
   import com.robot.core.manager.alert.AlertInfo;
   
   public class PetInBagAlarm extends BaseAlert
   {
      public function PetInBagAlarm(info:AlertInfo)
      {
         super(info,"UI_PetSwitchAlert","pet");
      }
   }
}

