package com.robot.core.ui.loading.loadingstyle
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   
   public class EmptyLoadingStyle extends EventDispatcher implements ILoadingStyle
   {
      public function EmptyLoadingStyle()
      {
         super();
      }
      
      public function changePercent(total:Number, loaded:Number) : void
      {
      }
      
      public function close() : void
      {
      }
      
      public function show() : void
      {
      }
      
      public function destroy() : void
      {
      }
      
      public function setTitle(str:String) : void
      {
      }
      
      public function setIsShowCloseBtn(i:Boolean) : void
      {
      }
      
      public function getParentMC() : DisplayObjectContainer
      {
         return null;
      }
      
      public function getLoadingMC() : DisplayObject
      {
         return null;
      }
   }
}

