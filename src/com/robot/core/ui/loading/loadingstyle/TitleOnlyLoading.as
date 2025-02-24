package com.robot.core.ui.loading.loadingstyle
{
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class TitleOnlyLoading extends BaseLoadingStyle implements ILoadingStyle
   {
      private static const KEY:String = "titleOnlyLoading";
      
      protected var titleText:TextField;
      
      public function TitleOnlyLoading(parentMC:DisplayObjectContainer, title:String = "Loading...", showCloseBtn:Boolean = false)
      {
         super(parentMC,showCloseBtn);
         this.titleText = loadingMC["content_txt"];
         this.titleText.autoSize = TextFieldAutoSize.CENTER;
         this.titleText.text = title;
      }
      
      override public function changePercent(total:Number, loaded:Number) : void
      {
         super.changePercent(total,loaded);
      }
      
      override public function setTitle(str:String) : void
      {
         this.titleText.text = str;
      }
      
      override public function destroy() : void
      {
         this.titleText = null;
         super.destroy();
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

