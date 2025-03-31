package com.robot.app.mapProcess
{
   // import com.robot.app.task.taskscollection.Task716;
   import com.robot.core.manager.map.config.BaseMapProcess;
   
   public class MapProcess_327 extends BaseMapProcess
   {

      public function MapProcess_327()
      {
         super();
      }
      
      override protected function init() : void
      {
         conLevel["task716MC"].visible = false;
         // Task716.initTaskForMap327(this);
      }
      
      override public function destroy() : void
      {
         // Task716.destroy();
      }
   }
}

