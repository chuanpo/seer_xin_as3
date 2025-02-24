package org.taomee.component.control
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextFormatAlign;
   import org.taomee.component.UIComponent;
   import org.taomee.component.event.ButtonEvent;
   import org.taomee.component.manager.MComponentManager;
   
   [Event(name="releaseOutside",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="release",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="press",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="onRollOver",type="org.taomee.component.event.ButtonEvent")]
   [Event(name="onRollOut",type="org.taomee.component.event.ButtonEvent")]
   public class MButton extends UIComponent
   {
      protected var bg:MovieClip;
      
      protected var offSetY:uint = 1;
      
      private var defaultFilterColor:uint = 676248;
      
      private var oldY:Number;
      
      protected var isDown:Boolean = false;
      
     // [Embed(source="../resource/componentUI.swf",symbol="button_bg")]
      private var bgClass:Class = MButton_bgClass;
      
      protected var _label:MLabel;
      
      private var defaultTxtColor:uint = 16777215;
      
      public function MButton(str:String = "Button")
      {
         super();
         this.mouseChildren = false;
         _label = new MLabel(str);
         _label.mouseChildren = false;
         _label.mouseEnabled = false;
         initUI();
         initHandler();
      }
      
      protected function press() : void
      {
         _label.y = oldY;
         bg.gotoAndStop(3);
         dispatchEvent(new ButtonEvent(ButtonEvent.PRESS));
      }
      
      protected function release() : void
      {
         _label.y = oldY - offSetY;
         bg.gotoAndStop(2);
         dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE));
      }
      
      private function downHandler(event:MouseEvent) : void
      {
         isDown = true;
         press();
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         label.width = value;
         bg.width = value;
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         label.y = (height - label.height) / 2;
         bg.height = value;
         oldY = label.y;
      }
      
      private function overHandler(event:MouseEvent) : void
      {
         if(isDown)
         {
            press();
         }
         else
         {
            mouseOver();
         }
      }
      
      protected function mouseOver() : void
      {
         _label.y = oldY - offSetY;
         bg.gotoAndStop(2);
         dispatchEvent(new ButtonEvent(ButtonEvent.ON_ROLL_OVER));
      }
      
      public function set text(str:String) : void
      {
         _label.text = str;
      }
      
      private function outHandler(event:MouseEvent) : void
      {
         if(isDown)
         {
            mouseOver();
         }
         else
         {
            mouseOut();
         }
      }
      
      protected function releaseOutside() : void
      {
         _label.y = oldY;
         bg.gotoAndStop(1);
         dispatchEvent(new ButtonEvent(ButtonEvent.RELEASE_OUTSIDE));
      }
      
      private function stageUpHandler(event:MouseEvent) : void
      {
         if(isDown)
         {
            releaseOutside();
         }
         isDown = false;
      }
      
      private function initHandler() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,outHandler);
         this.addEventListener(MouseEvent.MOUSE_DOWN,downHandler);
         this.addEventListener(MouseEvent.MOUSE_UP,upHandler);
         MComponentManager.stage.addEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
      }
      
      protected function mouseOut() : void
      {
         _label.y = oldY;
         bg.gotoAndStop(1);
         dispatchEvent(new ButtonEvent(ButtonEvent.ON_ROLL_OUT));
      }
      
      protected function initUI() : void
      {
         bg = new bgClass();
         bg.gotoAndStop(1);
         addChild(bg);
         _label.blod = true;
         _label.align = TextFormatAlign.CENTER;
         label.textField.filters = [new GlowFilter(defaultFilterColor,0.8,4,4,10)];
         addChild(_label);
         width = 65;
         height = 30;
         if(_label.width > 65 - 20)
         {
            width = _label.width + 20;
         }
         if(_label.height > 30 - 4)
         {
            height = _label.height + 4;
         }
         label.textColor = defaultTxtColor;
      }
      
      private function upHandler(event:MouseEvent) : void
      {
         if(isDown)
         {
            release();
         }
         isDown = false;
      }
      
      public function get label() : MLabel
      {
         return _label;
      }
   }
}

