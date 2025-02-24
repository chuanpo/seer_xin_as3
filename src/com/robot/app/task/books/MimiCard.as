package com.robot.app.task.books
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MimiCard
   {
      private static var mc:MovieClip;
      
      private static var PATH:String = "resource/book/mimicard.swf";
      
      public function MimiCard()
      {
         super();
      }
      
      public static function loadPanel() : void
      {
         var loader:MCLoader = null;
         if(!mc)
         {
            loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在打开米米卡手册");
            loader.addEventListener(MCLoadEvent.SUCCESS,onLoad);
            loader.doLoad();
         }
         else
         {
            mc.gotoAndStop(1);
            show();
         }
      }
      
      private static function onLoad(event:MCLoadEvent) : void
      {
         mc = event.getContent() as MovieClip;
         show();
      }
      
      private static function show() : void
      {
         DisplayUtil.align(mc,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(mc);
         var closeBtn:SimpleButton = mc["closeBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,closeHandler);
      }
      
      private static function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(mc);
         LevelManager.openMouseEvent();
         mc = null;
      }
   }
}

