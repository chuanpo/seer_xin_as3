package com.robot.app.task.SeerInstructor
{
   import com.robot.core.CommandID;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.Sprite;
   import flash.events.Event;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class InstructorExam
   {
      private static var loader:MCLoader;
      
      private static var gamePanel:*;
      
      private static var curGame:Sprite;
      
      private static var PATH:String = "resource/Games/InstructorExam/Questions.swf";
      
      public function InstructorExam()
      {
         super();
      }
      
      public static function loadGame() : void
      {
         loader = new MCLoader(PATH,LevelManager.topLevel,1,"正在加载教官考试题目");
         loader.addEventListener(MCLoadEvent.SUCCESS,onLoad);
         loader.doLoad();
      }
      
      private static function onLoad(event:MCLoadEvent) : void
      {
         loader.removeEventListener(MCLoadEvent.SUCCESS,onLoad);
         LevelManager.topLevel.addChild(event.getContent());
         DisplayUtil.align(event.getContent(),null,AlignType.MIDDLE_CENTER);
         curGame = event.getContent() as Sprite;
         event.getContent().addEventListener("instructorExamOver",onGameOver);
      }
      
      private static function onGameOver(e:Event) : void
      {
         gamePanel = e.target as Sprite;
         var obj:Object = gamePanel.obj;
         if(obj.flag == 0)
         {
            curGame.mouseChildren = false;
            curGame.mouseEnabled = false;
            Alarm.show("你成功通过了教官预考,点击右上角图标查看考核内容",okFun);
         }
         else if(obj.flag == 1)
         {
            curGame.mouseChildren = false;
            curGame.mouseEnabled = false;
            Alarm.show("你没有通过了教官预考,下次继续努力吧",failFun);
         }
         else if(obj.flag == 2)
         {
            LevelManager.topLevel.removeChild(curGame);
         }
      }
      
      private static function okFun() : void
      {
         trace(TasksManager.taskList[200]);
         TasksManager.accept(201,onAccept);
      }
      
      private static function onAccept(b:Boolean) : void
      {
         if(b)
         {
            TasksManager.setTaskStatus(NewInstructorContoller.TASK_ID,TasksManager.ALR_ACCEPT);
            LevelManager.topLevel.removeChild(curGame);
            NewInstructorContoller.showIcon();
         }
      }
      
      private static function onChangeOK(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.CHANGE_TASK_STATUES,onChangeOK);
         TasksManager.taskList[200] = 2;
         LevelManager.topLevel.removeChild(curGame);
         SeerInstructorMain.start();
      }
      
      private static function failFun() : void
      {
         LevelManager.topLevel.removeChild(curGame);
      }
   }
}

