package com.robot.app.petbag.petPropsBag.petPropClass
{
   import com.robot.app.petItem.StudyUpManager;
   import com.robot.app.petbag.PetPropInfo;
   
   public class PetPropClass_300035
   {
      public function PetPropClass_300035(info:PetPropInfo)
      {
         super();
         StudyUpManager.useItem(info.itemId);
      }
   }
}

