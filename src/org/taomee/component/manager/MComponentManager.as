package org.taomee.component.manager
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import org.taomee.component.tips.ToolTip;
   
   public class MComponentManager
   {
      public static var root:DisplayObjectContainer;
      
      public static var stage:Stage;
      
      public static var font:String;
      
      public static var fontSize:uint;
      
      public static var bgAlpha:Number;
      
      public function MComponentManager()
      {
         super();
      }
      
      public static function get stageWidth() : Number
      {
         return stage.stageWidth;
      }
      
      public static function get stageHeight() : Number
      {
         return stage.stageHeight;
      }
      
      public static function setup(_root:DisplayObjectContainer, _fontSize:uint = 12, _font:String = "Arial", _bgAlpha:Number = 0) : void
      {
         root = _root;
         stage = _root.stage;
         fontSize = _fontSize;
         font = _font;
         bgAlpha = _bgAlpha;
         ToolTip.setup();
      }
   }
}

