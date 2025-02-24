package com.robot.core.ui.alert2
{
   import com.robot.core.manager.alert.AlertInfo;
   
   public class PetInStorageAlarm extends BaseAlert
   {
      public function PetInStorageAlarm(info:AlertInfo)
      {
         super(info,"UI_PetInStorageAlert","pet");
      }
   }
}

