package com.robot.app.spacesurvey
{
   public class SpaceSurveyResultController
   {
      private static var _panel:SpaceSurveyResult;
      
      public function SpaceSurveyResultController()
      {
         super();
      }
      
      public static function show(str:String) : void
      {
         if(!_panel)
         {
            _panel = new SpaceSurveyResult();
         }
         _panel.show(str);
      }
   }
}

