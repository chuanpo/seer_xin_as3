package org.taomee.component.control
{
   import flash.text.TextFieldAutoSize;
   import org.taomee.component.ITextContentComponent;
   
   public class MText extends MLabel implements ITextContentComponent
   {
      public function MText(str:String = "")
      {
         super(str);
         txt.selectable = true;
         txt.wordWrap = true;
         txt.autoSize = TextFieldAutoSize.LEFT;
         if(str == "")
         {
            text = "";
         }
         txt.setTextFormat(tf);
         width = txt.width;
         height = txt.height;
      }
   }
}

