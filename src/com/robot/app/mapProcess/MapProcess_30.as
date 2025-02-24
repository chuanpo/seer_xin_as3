package com.robot.app.mapProcess
{
   import com.robot.app.spacesurvey.SpaceSurveyTool;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import flash.display.Sprite;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_30 extends BaseMapProcess
   {
      private var aliceMc:Sprite;
      
      private var bombGameMc:AppModel;
      
      public function MapProcess_30()
      {
         super();
      }
      
      override protected function init() : void
      {
         SpaceSurveyTool.getInstance().show("赫尔卡星");
         ToolTipManager.add(conLevel["cubeMc"],"拆弹游戏");
      }
      
      override public function destroy() : void
      {
         SpaceSurveyTool.getInstance().hide();
         if(Boolean(this.bombGameMc))
         {
            this.bombGameMc = null;
         }
         ToolTipManager.remove(conLevel["cubeMc"]);
      }
      
      public function onBombGameHandler() : void
      {
         if(TasksManager.getTaskStatus(9) == TasksManager.UN_ACCEPT)
         {
            TasksManager.accept(9,this.onCompleteHandler);
            return;
         }
         this.onCompleteHandler(true);
      }
      
      private function onCompleteHandler(b1:Boolean) : void
      {
         if(b1)
         {
            if(!this.bombGameMc)
            {
               this.bombGameMc = new AppModel(ClientConfig.getGameModule("BombGame"),"正在打开拆弹游戏");
               this.bombGameMc.setup();
            }
            this.bombGameMc.show();
         }
      }
   }
}

