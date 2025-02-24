package com.robot.app.task.books
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.DisplayUtil;
   
   public class InstructorBook
   {
      private static var mc:MovieClip;
      
      private static var app:ApplicationDomain;
      
      private static var mainPanel:MovieClip;
      
      private static var PATH:String = "resource/book/instructorBook.swf";
      
      public function InstructorBook()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var loader:MCLoader = null;
         if(!mc)
         {
            loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开教官手册");
            loader.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            loader.doLoad();
         }
         else
         {
            mc.gotoAndStop(1);
            mainPanel.gotoAndStop(1);
            show();
         }
      }
      
      private static function onLoad(event:MCLoadEvent) : void
      {
         app = event.getApplicationDomain();
         mc = new (app.getDefinition("instructorBook") as Class)() as MovieClip;
         mainPanel = mc["mainPanel"];
         mc.x = 496.55;
         mc.y = 276.7;
         mainPanel.stop();
         mc.cacheAsBitmap = true;
         show();
      }
      
      private static function show() : void
      {
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mc);
         var closeBtn:SimpleButton = mc["exitBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
      }
   }
}

