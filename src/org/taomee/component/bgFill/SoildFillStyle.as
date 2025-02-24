package org.taomee.component.bgFill
{
   import flash.display.Sprite;
   import org.taomee.component.UIComponent;
   
   public class SoildFillStyle implements IBgFillStyle
   {
      private var fillColor:uint = 16777215;
      
      private var elipseWidth:Number;
      
      private var bgAlpha:Number;
      
      private var bgMC:Sprite;
      
      private var elipseHeight:Number;
      
      public function SoildFillStyle(fillColor:uint = 16777215, bgAlpha:Number = 1, elipseWidth:Number = 0, elipseHeight:Number = 0)
      {
         super();
         this.fillColor = fillColor;
         this.bgAlpha = bgAlpha;
         this.elipseHeight = elipseHeight;
         this.elipseWidth = elipseWidth;
      }
      
      public function draw(bgMC:Sprite) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         this.bgMC = bgMC;
         this.bgMC.graphics.beginFill(fillColor,bgAlpha);
         w = UIComponent(this.bgMC.parent).width;
         h = UIComponent(this.bgMC.parent).height;
         this.bgMC.graphics.drawRoundRect(0,0,w,h,elipseWidth,elipseHeight);
         this.bgMC.graphics.endFill();
      }
      
      public function clear() : void
      {
         bgMC.graphics.clear();
         bgMC = null;
      }
      
      public function reDraw() : void
      {
         if(Boolean(bgMC))
         {
            bgMC.graphics.clear();
         }
         draw(bgMC);
      }
   }
}

