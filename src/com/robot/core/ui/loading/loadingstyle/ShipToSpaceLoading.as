package com.robot.core.ui.loading.loadingstyle
{
   import flash.display.DisplayObjectContainer;
   
   public class ShipToSpaceLoading extends TitlePercentLoading implements ILoadingStyle
   {
      private static const KEY:String = "ShipToSpaceLoading";
      
      public function ShipToSpaceLoading(parentMC:DisplayObjectContainer, title:String = "Loading...", showCloseBtn:Boolean = false)
      {
         super(parentMC,title,showCloseBtn);
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

