package com.robot.app.mapProcess
{
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.app.spacesurvey.SpaceSurveyTool;
   import com.robot.app.task.control.TaskController_90;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.OgreModel;
   import com.robot.core.npc.NpcController;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class MapProcess_10 extends BaseMapProcess
   {
      private var pipi_npc:OgreModel;
      
      private var _pipi_mc:MovieClip;
      
      private var _pipi_pic:MovieClip;
      
      public function MapProcess_10()
      {
         super();
      }
      
      override protected function init() : void
      {
         SpaceSurveyTool.getInstance().show("克洛斯星");
         this._pipi_mc = topLevel["pipi_mc"];
         this._pipi_mc.gotoAndStop(1);
         this._pipi_mc.visible = false;
         if(TasksManager.getTaskStatus(TaskController_90.TASK_ID) == TasksManager.COMPLETE)
         {
            if(Boolean(NpcController.curNpc))
            {
               this.addEventNpc();
            }
            return;
         }
         this._pipi_pic = MapLibManager.getMovieClip("Pipipic");
         topLevel.addChild(this._pipi_pic);
         this._pipi_pic.x = 2000;
         this._pipi_pic.y = 97;
         TasksManager.getProStatusList(TaskController_90.TASK_ID,function(arr:Array):void
         {
            TaskController_90.initFun(delAdd,_pipi_mc,_pipi_pic);
            if(Boolean(arr[0]))
            {
               addEventNpc();
            }
         });
      }
      
      private function addEventNpc() : void
      {
         this._pipi_mc.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
      }
      
      private function enterFrameHandler(e:Event) : void
      {
         if(Boolean(NpcController.curNpc))
         {
            this._pipi_mc.removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            NpcController.curNpc.npc.npc.visible = false;
         }
      }
      
      private function clickPIPIHandler(e:MouseEvent) : void
      {
         TaskController_90.clickPIPI();
      }
      
      public function exploitOre() : void
      {
         EnergyController.exploit();
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
      }
      
      private function delAdd() : void
      {
      }
      
      override public function destroy() : void
      {
      }
   }
}

