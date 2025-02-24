package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.event.RobotEvent;
   import com.robot.core.manager.LoadingManager;
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   [Event(name="closeLoading",type="com.event.LoadingEvent")]
   public class BaseLoadingStyle extends EventDispatcher implements ILoadingStyle
   {
      private static const KEY:String = "baseLoading";
      
      protected var loadingMC:MovieClip;
      
      protected var parentMC:DisplayObjectContainer;
      
      protected var percent:Number;
      
      protected var isShowCloseBtn:Boolean;
      
      private var closeBtn:InteractiveObject;
      
      public function BaseLoadingStyle(parentMC:DisplayObjectContainer = null, showCloseBtn:Boolean = false)
      {
         super();
         this.isShowCloseBtn = showCloseBtn;
         this.parentMC = parentMC;
         this.loadingMC = LoadingManager.getMovieClip(this.getKey());
         this.closeBtn = this.loadingMC["closeBtn"];
         this.initPosition();
         this.checkIsShowCloseBtn();
      }
      
      protected function initPosition() : void
      {
         var W:Number = NaN;
         var H:Number = NaN;
         if(this.parentMC == null)
         {
            this.parentMC = MainManager.getStage();
            W = MainManager.getStageWidth();
            H = MainManager.getStageHeight();
         }
         else
         {
            W = MainManager.getStageWidth();
            H = MainManager.getStageHeight();
         }
         this.loadingMC.x = (W - this.loadingMC.width) / 2;
         this.loadingMC.y = (H - this.loadingMC.height) / 2;
         if(Boolean(this.parentMC))
         {
            this.parentMC.addChild(this.loadingMC);
         }
      }
      
      protected function checkIsShowCloseBtn() : void
      {
         if(this.closeBtn != null)
         {
            if(this.closeBtn is Sprite)
            {
               Sprite(this.closeBtn).buttonMode = true;
            }
            this.closeBtn.visible = this.isShowCloseBtn;
            this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         }
      }
      
      public function changePercent(total:Number, loaded:Number) : void
      {
         this.percent = Math.floor(loaded / total * 100);
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         dispatchEvent(new RobotEvent(RobotEvent.CLOSE_LOADING));
      }
      
      public function show() : void
      {
         if(Boolean(this.parentMC))
         {
            this.parentMC.addChild(this.loadingMC);
         }
      }
      
      public function close() : void
      {
         DisplayUtil.removeForParent(this.loadingMC);
      }
      
      public function destroy() : void
      {
         if(this.closeBtn != null)
         {
            this.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
            this.closeBtn = null;
         }
         DisplayUtil.removeForParent(this.loadingMC);
         this.loadingMC = null;
         this.parentMC = null;
      }
      
      public function getLoadingMC() : DisplayObject
      {
         return this.loadingMC;
      }
      
      public function getParentMC() : DisplayObjectContainer
      {
         return this.parentMC;
      }
      
      public function setIsShowCloseBtn(i:Boolean) : void
      {
         this.isShowCloseBtn = i;
         this.checkIsShowCloseBtn();
      }
      
      public function setTitle(str:String) : void
      {
      }
      
      protected function getKey() : String
      {
         return KEY;
      }
   }
}

