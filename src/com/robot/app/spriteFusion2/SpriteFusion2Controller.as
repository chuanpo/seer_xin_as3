package com.robot.app.spriteFusion2
{   
   public class SpriteFusion2Controller
   {
      private static var _panel:SpriteFusionPanel2;
      
      public function SpriteFusion2Controller()
      {
         super();
      }
      
      public static function show() : void
      {
         if(_panel != null)
         {
            _panel.destroy();
            _panel = null;
         }
         _panel = new SpriteFusionPanel2();
         _panel.show();
      }
   }
}

