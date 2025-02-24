package com.robot.app.task.noviceGuide.GuideTaskAfter
{
   import com.robot.app.task.taskUtils.manage.TaskUIManage;
   import com.robot.app.task.taskUtils.taskDialog.TaskBaseDialog;
   import flash.display.MovieClip;
   
   public class GetSyrup
   {
      private static var sDialog:MovieClip;
      
      public function GetSyrup()
      {
         super();
      }
      
      public static function show(str:String = "", fun:Function = null) : void
      {
         sDialog = TaskUIManage.getMovieClip("priWater",4);
         TaskBaseDialog.dialogMC = sDialog;
         TaskBaseDialog.showAwardDialog(str,fun);
      }
   }
}

