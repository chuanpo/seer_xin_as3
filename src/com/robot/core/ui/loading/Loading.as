package com.robot.core.ui.loading
{
   import com.robot.core.ui.loading.loadingstyle.BaseLoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.EmptyLoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.ILoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.MainLoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.ShipToSpaceLoading;
   import com.robot.core.ui.loading.loadingstyle.TitleOnlyLoading;
   import com.robot.core.ui.loading.loadingstyle.TitlePercentLoading;
   import flash.display.DisplayObjectContainer;
   
   public class Loading
   {
      public static const NO_ALL:int = -1;
      
      public static const TITLE_AND_PERCENT:int = 1;
      
      public static const JUST_TITLE:int = 0;
      
      public static const ICON_ONLY:int = 2;
      
      public static const MAIN_LOAD:int = 3;
      
      public static const SHIP_TO_SPACE:int = 4;
      
      public function Loading()
      {
         super();
      }
      
      public static function getLoadingStyle(style:int, parentMC:DisplayObjectContainer, title:String = "Loading...", isShowCloseBtn:Boolean = false) : ILoadingStyle
      {
         var loadingStyle:ILoadingStyle = null;
         switch(style)
         {
            case NO_ALL:
               loadingStyle = new EmptyLoadingStyle();
               break;
            case MAIN_LOAD:
               loadingStyle = new MainLoadingStyle(parentMC,title,isShowCloseBtn);
               break;
            case TITLE_AND_PERCENT:
               loadingStyle = new TitlePercentLoading(parentMC,title,isShowCloseBtn);
               break;
            case JUST_TITLE:
               loadingStyle = new TitleOnlyLoading(parentMC,title,isShowCloseBtn);
               break;
            case ICON_ONLY:
               loadingStyle = new BaseLoadingStyle(parentMC,isShowCloseBtn);
               break;
            case SHIP_TO_SPACE:
               loadingStyle = new ShipToSpaceLoading(parentMC,title,isShowCloseBtn);
               break;
            default:
               loadingStyle = new EmptyLoadingStyle();
         }
         return loadingStyle;
      }
   }
}

