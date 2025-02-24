package org.taomee.component.control
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import org.taomee.utils.DisplayUtil;
   
   public class MCheckBox extends MButton
   {
      private var isInitUI:Boolean = false;
      
      protected var selectedBox:Sprite;
      
      //[Embed(source="../resource/componentUI.swf",symbol="checkBox_empty")]
      private var labelEmptyCls:Class = MCheckBox_labelEmptyCls;
      
      protected var _selected:Boolean = false;
      
      //[Embed(source="../resource/componentUI.swf",symbol="checkBox_selected")]
      private var labelSelectedCls:Class = MCheckBox_labelSelectedCls;
      
      protected var gap:uint = 4;
      
      protected var emptyBox:Sprite;
      
      public function MCheckBox(str:String = "CheckBox")
      {
         super(str);
         offSetY = 0;
      }
      
      override protected function initUI() : void
      {
         bg = new MovieClip();
         _label.blod = false;
         _label.align = TextFormatAlign.LEFT;
         _label.textField.filters = [];
         _label.textColor = 0;
         containSprite.mouseChildren = false;
         containSprite.mouseEnabled = false;
         emptyBox = new labelEmptyCls() as Sprite;
         selectedBox = new labelSelectedCls() as Sprite;
         containSprite.addChild(emptyBox);
         label.x = emptyBox.width + gap;
         containSprite.addChild(label);
         emptyBox.y = selectedBox.y = (containSprite.height - emptyBox.height) / 2;
         label.y = (containSprite.height - label.textField.textHeight) / 2;
         isInitUI = true;
         setSizeWH(containSprite.width,containSprite.height);
      }
      
      public function set selected(b:Boolean) : void
      {
         _selected = b;
         if(_selected)
         {
            containSprite.addChild(selectedBox);
            DisplayUtil.removeForParent(emptyBox);
         }
         else
         {
            containSprite.addChild(emptyBox);
            DisplayUtil.removeForParent(selectedBox);
         }
      }
      
      override protected function release() : void
      {
         selected = !selected;
         super.release();
      }
      
      override protected function revalidate() : void
      {
         if(!isInitUI)
         {
            return;
         }
         super.revalidate();
         emptyBox.y = selectedBox.y = (containSprite.height - emptyBox.height) / 2;
         label.y = (containSprite.height - label.textField.textHeight) / 2;
      }
      
      public function get selected() : Boolean
      {
         return _selected;
      }
      
      override public function set width(value:Number) : void
      {
         super.width = value;
         label.width = value - emptyBox.width - gap;
      }
   }
}

