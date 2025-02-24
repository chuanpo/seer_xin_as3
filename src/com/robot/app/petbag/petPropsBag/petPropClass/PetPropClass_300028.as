package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.automaticFight.AutomaticFightManager;
   import com.robot.app.petbag.PetPropInfo;
   
   public class PetPropClass_300028
   {
      public function PetPropClass_300028(info:PetPropInfo)
      {
         super();
         AutomaticFightManager.useItem(info.itemId);
      }
   }
}

