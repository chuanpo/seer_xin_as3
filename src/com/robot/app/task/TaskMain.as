package com.robot.app.task
{
   import com.robot.app.automaticFight.AutomaticFightManager;
   import com.robot.app.control.GuoqingsignupController;
   import com.robot.app.petItem.StudyUpManager;
   import com.robot.app.spt.PioneerTaskIconController;
   import com.robot.app.task.SeerInstructor.NewInstructorContoller;
   import com.robot.app.task.conscribeTeam.ConscribeTeam;
   import com.robot.app.task.control.TaskController_25;
   import com.robot.app.task.dailyTask.DailyTaskController;
   import com.robot.app.task.newNovice.NewNoviceGuideTaskController;
   import com.robot.app.task.publicizeenvoy.PublicizeEnvoyIconControl;
   import com.robot.app.tasksRecord.TasksRecordController;
   import com.robot.core.manager.HatchTaskMapManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.npc.NpcController;
   import com.robot.core.teamPK.TeamPKManager;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.EventManager;
   
   public class TaskMain extends BaseBeanController
   {
      public function TaskMain()
      {
         super();
      }
      
      override public function start() : void
      {
         PioneerTaskIconController.createIcon();
         DailyTaskController.setup();
         TasksRecordController.setup();
         NewInstructorContoller.setup();
         ConscribeTeam.setup();
         TaskController_25.start();
         EventManager.addEventListener("DS_TASK",this.onDsTask);
         if(MainManager.actorInfo.teamPKInfo.homeTeamID > 50000)
         {
            TeamPKManager.showIcon();
         }
         GuoqingsignupController.createIcon();
         finish();
         AutomaticFightManager.setup();
         StudyUpManager.setup();
         HatchTaskMapManager.setup();
         NewNoviceGuideTaskController.setup();
         NpcController.setup();
      }
      
      private function onDsTask(event:DynamicEvent) : void
      {
         MainManager.actorInfo.newInviteeCnt = uint(event.paramObject);
         if(MainManager.actorInfo.newInviteeCnt >= 2)
         {
            PublicizeEnvoyIconControl.lightIcon();
         }
      }
   }
}

