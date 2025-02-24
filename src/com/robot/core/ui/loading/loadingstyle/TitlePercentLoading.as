package com.robot.core.ui.loading.loadingstyle
{
   import com.robot.core.config.UpdateConfig;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Timer;
   
   public class TitlePercentLoading extends TitleOnlyLoading implements ILoadingStyle
   {
      private static const KEY:String = "titlePercentLoading";
      
      protected var percentText:TextField;
      
      protected var percentBar:MovieClip;
      
      private var barWidth:Number;
      
      private var showCloseBtn:Boolean = true;
      
      private var tipTxt:TextField;
      
      private var timer:Timer;
      
      public function TitlePercentLoading(parentMC:DisplayObjectContainer, title:String = "Loading...", showCloseBtn:Boolean = false)
      {
         super(parentMC,title,this.showCloseBtn);
         this.percentText = loadingMC["perNum"];
         this.percentText.text = "0%";
         this.tipTxt = loadingMC["tip_txt"];
         this.percentBar = loadingMC["loadingBar"];
         this.barWidth = 200;
         var array:Array = UpdateConfig.loadingArray.slice();
         var num:uint = Math.floor(Math.random() * array.length);
         this.tipTxt.text = array[num];
         this.timer = new Timer(2000);
         this.timer.addEventListener(TimerEvent.TIMER,this.changeTip);
         this.timer.start();
      }
      
      private function changeTip(event:TimerEvent) : void
      {
         var array:Array = UpdateConfig.loadingArray.slice();
         var num:uint = Math.floor(Math.random() * array.length);
         this.tipTxt.text = array[num];
      }
      
      override public function changePercent(total:Number, loaded:Number) : void
      {
         super.changePercent(total,loaded);
         this.percentText.text = percent + "%";
         this.percentBar.gotoAndStop(percent);
      }
      
      override public function setTitle(str:String) : void
      {
         super.setTitle(str);
      }
      
      override public function destroy() : void
      {
         this.percentText = null;
         this.percentBar = null;
         this.tipTxt = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.changeTip);
         this.timer = null;
         super.destroy();
      }
      
      override protected function getKey() : String
      {
         return KEY;
      }
   }
}

