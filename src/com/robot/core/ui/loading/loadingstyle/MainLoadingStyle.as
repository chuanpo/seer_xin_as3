package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObjectContainer;
   
   public class MainLoadingStyle extends TitlePercentLoading implements ILoadingStyle
   {
      private static const KEY:String = "mainLoad";
      
      public function MainLoadingStyle(parentMC:DisplayObjectContainer, title:String = "Loading...", showCloseBtn:Boolean = false)
      {
         super(parentMC,title,showCloseBtn);
      }
      
      override protected function initPosition() : void
      {
         if(parentMC == null)
         {
            parentMC = MainManager.getStage();
         }
         parentMC.addChild(loadingMC);
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

