package com.robot.app.other.filter
{
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.ui.alert.Alarm;

   public class FilterPanelController
   {
      private static var _panel:FilterPanel;

      public function FilterPanelController()
      {
         super();
      }

      public static function get panel():FilterPanel
      {
         if (_panel == null)
         {
            _panel = new FilterPanel();
         }
         return _panel;
      }

      public static function show():void
      {
         if (!DisplayUtil.hasParent(panel))
         {
            panel.show();
         }
      }
   }
}
