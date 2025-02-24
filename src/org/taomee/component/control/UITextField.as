package org.taomee.component.control
{
   import flash.text.TextField;
   import org.taomee.component.UIComponent;
   
   internal class UITextField extends UIComponent
   {
      public var txt:TextField;
      
      public function UITextField(txt:TextField)
      {
         super();
         this.txt = txt;
         addChild(txt);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         txt = null;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         txt.width = value;
      }
      
      override public function set height(value:Number) : void
      {
         super.height = value;
         txt.height = value;
      }
   }
}

