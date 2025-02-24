package com.robot.app.mapProcess
{
   import com.robot.app.help.HelpManager;
   import com.robot.app.task.SeerInstructor.NewInstructorContoller;
   import com.robot.app.task.control.TaskController_98;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.animate.AnimateManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.DialogBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class MapProcess_3 extends BaseMapProcess
   {
      private var btn:Sprite;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      public function MapProcess_3()
      {
         super();
      }
      
      override protected function init() : void
      {
         var btn1:Sprite = null;
         this.showTask98();
         this.btn = new Sprite();
         this.btn.graphics.beginFill(65280);
         this.btn.graphics.drawRect(0,0,80,137);
         this.btn.width = 80;
         this.btn.height = 137;
         this.btn.x = 180;
         this.btn.y = 80;
         this.btn.alpha = 0;
         this.btn.buttonMode = true;
         conLevel.addChild(this.btn);
         this.btn.addEventListener(MouseEvent.CLICK,this.showTip);
         btn1 = new Sprite();
         btn1.graphics.beginFill(65280);
         btn1.graphics.drawRect(0,0,145,137);
         btn1.width = 145;
         btn1.height = 137;
         btn1.x = 670;
         btn1.y = 64;
         btn1.alpha = 0;
         btn1.buttonMode = true;
         conLevel.addChild(btn1);
         btn1.addEventListener(MouseEvent.CLICK,this.showTip);
         this.wbMc = conLevel["hitWbMC"];
         this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
      }
      
      private function wbmcOverHandler(e:MouseEvent) : void
      {
         this.mbox = new DialogBox();
         this.mbox.show("有什么需要我帮助您的吗？",0,-30,conLevel["wbNpc"]);
      }
      
      private function wbmcOUTHandler(e:MouseEvent) : void
      {
         this.mbox.hide();
      }
      
      override public function destroy() : void
      {
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.wbMc = null;
         this.mbox = null;
         this.btn.removeEventListener(MouseEvent.CLICK,this.showTip);
         this.btn = null;
      }
      
      public function showWbAction() : void
      {
         var mc:MovieClip = conLevel["wbNpc"] as MovieClip;
         mc.gotoAndPlay(2);
      }
      
      private function showTip(e:MouseEvent) : void
      {
         NpcTipDialog.show("赛尔飞船的各个舱室是通过走廊来连接，你可以乘坐电梯穿梭于飞船各层。");
      }
      
      public function showTask() : void
      {
         if(TasksManager.getTaskStatus(NewInstructorContoller.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            NewInstructorContoller.fight();
         }
         else
         {
            HelpManager.show(0);
         }
      }
      
      private function showTask98() : void
      {
         if(TasksManager.getTaskStatus(TaskController_98.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(TaskController_98.TASK_ID,function(arr:Array):void
            {
               if(Boolean(arr[0]) && !arr[1])
               {
                  AnimateManager.playMcAnimate(btnLevel["task98_effect"],0,"",function():void
                  {
                     TasksManager.complete(TaskController_98.TASK_ID,1,function():void
                     {
                        btnLevel["task98_effect"].visible = false;
                     });
                  });
               }
            });
         }
      }
   }
}

