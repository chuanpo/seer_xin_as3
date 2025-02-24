package org.taomee.component.control
{
   import flash.display.MovieClip;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class MLabelButton extends MButton
   {
      private var _outColor:uint = 52223;
      
      private var _bgPressAlpha:Number = 0;
      
      private var _bgPressColor:uint;
      
      private var _bgOverAlpha:Number = 0;
      
      private var _bgOverColor:uint;
      
      private var _underLine:Boolean = false;
      
      private var _overColor:uint = 16763904;
      
      private var _bgOutAlpha:Number = 0;
      
      private var _bgOutColor:uint;
      
      public function MLabelButton(str:String = "Button")
      {
         super(str);
         offSetY = 0;
      }
      
      override protected function press() : void
      {
         super.press();
         _label.textColor = _overColor;
         drawPressBg();
      }
      
      private function drawPressBg() : void
      {
         bg.graphics.clear();
         bg.graphics.beginFill(_bgPressColor,_bgPressAlpha);
         bg.graphics.drawRect(0,0,1,1);
         bg.graphics.endFill();
      }
      
      override protected function release() : void
      {
         super.release();
         _label.textColor = _overColor;
         drawOverBg();
      }
      
      private function drawOutBg() : void
      {
         bg.graphics.clear();
         bg.graphics.beginFill(_bgOutColor,_bgOutAlpha);
         bg.graphics.drawRect(0,0,1,1);
         bg.graphics.endFill();
      }
      
      public function setBgColors(overColor:uint, outColor:uint, pressColor:uint, overAlpha:Number = 0.5, outAlpha:Number = 0.5, pressAlpha:Number = 0.5) : void
      {
         _bgOverColor = overColor;
         _bgOutColor = outColor;
         _bgPressColor = pressColor;
         _bgOverAlpha = overAlpha;
         _bgOutAlpha = outAlpha;
         _bgPressAlpha = pressAlpha;
         drawOutBg();
      }
      
      public function set underLine(b:Boolean) : void
      {
         _underLine = b;
         var tf:TextFormat = _label.textFormat;
         tf.underline = b;
         _label.textField.setTextFormat(tf);
      }
      
      override protected function mouseOver() : void
      {
         super.mouseOver();
         _label.textColor = _overColor;
         drawOverBg();
      }
      
      private function drawOverBg() : void
      {
         bg.graphics.clear();
         bg.graphics.beginFill(_bgOverColor,_bgOverAlpha);
         bg.graphics.drawRect(0,0,1,1);
         bg.graphics.endFill();
      }
      
      public function set overColor(i:uint) : void
      {
         _overColor = i;
      }
      
      override protected function releaseOutside() : void
      {
         super.releaseOutside();
         _label.textColor = _outColor;
         drawOutBg();
      }
      
      override protected function mouseOut() : void
      {
         super.mouseOut();
         _label.textColor = _outColor;
         drawOutBg();
      }
      
      public function set outColor(i:uint) : void
      {
         _outColor = i;
         label.textColor = _outColor;
      }
      
      override protected function initUI() : void
      {
         bg = new MovieClip();
         bg.mouseEnabled = false;
         drawOutBg();
         addChild(bg);
         _label.align = TextFormatAlign.LEFT;
         addChild(_label);
         width = label.width;
         height = label.height;
         label.textColor = _outColor;
      }
   }
}

