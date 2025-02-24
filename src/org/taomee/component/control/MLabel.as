package org.taomee.component.control
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import org.taomee.component.ITextContentComponent;
   import org.taomee.component.UIComponent;
   import org.taomee.component.manager.MComponentManager;
   
   public class MLabel extends UIComponent implements ITextContentComponent
   {
      private var htmlType:Boolean = false;
      
      private var oldStr:String;
      
      private var _cutToFit:Boolean = false;
      
      private var _autoFitWidth:Boolean = false;
      
      private var _isOverflow:Boolean = false;
      
      protected var txt:TextField;
      
      protected var tf:TextFormat;
      
      protected var uiTxt:UITextField;
      
      public function MLabel(str:String = "")
      {
         super();
         tf = new TextFormat();
         tf.size = MComponentManager.fontSize;
         tf.font = MComponentManager.font;
         tf.leading = 4;
         tf.letterSpacing = 1;
         uiTxt = new UITextField(new TextField());
         txt = uiTxt.txt;
         containSprite.addChild(uiTxt);
         txt.selectable = false;
         txt.wordWrap = false;
         if(str == "")
         {
            str = "MLabel";
         }
         oldStr = str;
         txt.text = str;
         txt.setTextFormat(tf);
         width = txt.textWidth + 2;
         height = txt.textHeight;
      }
      
      public function get textFormat() : TextFormat
      {
         return tf;
      }
      
      public function set autoFitWidth(b:Boolean) : void
      {
         _autoFitWidth = b;
         updateView();
      }
      
      override protected function revalidate() : void
      {
         var count:uint = 0;
         super.revalidate();
         txt.htmlText = oldStr;
         txt.setTextFormat(tf);
         _isOverflow = false;
         if(_autoFitWidth)
         {
            stopUpdate();
            _autoFitWidth = false;
            width = txt.textWidth + 2;
            _autoFitWidth = true;
            return;
         }
         if(!_cutToFit && !htmlType)
         {
            count = 0;
            while(txt.textWidth > width && oldStr.length - count > 1)
            {
               count++;
               txt.text = oldStr.substring(0,oldStr.length - count) + "...";
               txt.setTextFormat(tf);
               _isOverflow = true;
            }
            return;
         }
      }
      
      public function get isOverflow() : Boolean
      {
         return _isOverflow;
      }
      
      public function get textField() : TextField
      {
         return txt;
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         uiTxt.height = value;
      }
      
      public function set align(i:String) : void
      {
         tf.align = i;
         updateView();
      }
      
      public function set text(str:String) : void
      {
         htmlType = false;
         oldStr = str;
         txt.text = str;
         updateView();
      }
      
      override public function set width(value:Number) : void
      {
         if(!_autoFitWidth)
         {
            super.width = value;
            uiTxt.width = value;
         }
      }
      
      public function set fontSize(i:uint) : void
      {
         tf.size = i;
         updateView();
      }
      
      public function set cutToFit(b:Boolean) : void
      {
         _cutToFit = b;
         updateView();
      }
      
      public function set textColor(color:uint) : void
      {
         tf.color = color;
         updateView();
      }
      
      public function get text() : String
      {
         return oldStr;
      }
      
      public function set italic(b:Boolean) : void
      {
         if(b)
         {
            tf.italic = true;
         }
         else
         {
            tf.italic = null;
         }
         updateView();
      }
      
      public function set htmlText(str:String) : void
      {
         htmlType = true;
         oldStr = str;
         txt.htmlText = str;
         updateView();
      }
      
      override public function destroy() : void
      {
         super.destroy();
         uiTxt = null;
         txt = null;
      }
      
      public function set selectable(b:Boolean) : void
      {
         txt.selectable = b;
      }
      
      public function set blod(b:Boolean) : void
      {
         if(b)
         {
            tf.bold = true;
         }
         else
         {
            tf.bold = null;
         }
         updateView();
      }
      
      public function get htmlText() : String
      {
         return oldStr;
      }
   }
}

