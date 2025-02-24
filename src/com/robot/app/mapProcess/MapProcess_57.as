package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.mapProcess.active.SuperNonoIndex;
   import com.robot.app.task.control.TaskController_79;
   import com.robot.app.task.control.TaskController_81;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_57 extends BaseMapProcess
   {
      private var _markMc:MovieClip;
      
      private var _long_mc:MovieClip;
      
      private var _hua_btn:SimpleButton;
      
      private var _dh_mc:MovieClip;
      
      private var pet_btn:SimpleButton;
      
      public function MapProcess_57()
      {
         super();
         this._markMc = depthLevel["markMc"];
         this._hua_btn = btnLevel["hua_btn"];
         this.pet_btn = depthLevel["pet_btn"];
         ToolTipManager.add(this._hua_btn,"花蕊");
         this._dh_mc = depthLevel["dh_mc"];
         this._dh_mc.gotoAndStop(1);
         this._markMc.visible = false;
         this._long_mc = btnLevel["longNpc"];
         this._long_mc.buttonMode = true;
         this._long_mc.addEventListener(MouseEvent.CLICK,this.clickLongHandler);
         this.initTask79();
         this.initTask81();
      }
      
      private function initTask79() : void
      {
         if(TasksManager.getTaskStatus(TaskController_79.TASK_ID) == TasksManager.COMPLETE)
         {
            this._long_mc.visible = false;
         }
         TasksManager.getProStatusList(TaskController_79.TASK_ID,function(arr:Array):void
         {
            if(Boolean(arr[0]))
            {
               _long_mc.visible = false;
            }
         });
      }
      
      private function clickHuaHandler(e:MouseEvent) : void
      {
         if(this._dh_mc.currentFrame != 40)
         {
            return;
         }
         this._dh_mc.gotoAndPlay(42);
         this._dh_mc.addFrameScript(81,this.endDh1);
      }
      
      private function endDh1() : void
      {
         this._dh_mc.gotoAndStop(81);
         this._dh_mc.addFrameScript(81,null);
         TaskController_81.speek0();
      }
      
      private function clickPetHandler(e:MouseEvent) : void
      {
         this.pet_btn.visible = false;
         if(this._dh_mc.currentFrame == 81)
         {
            this._dh_mc.gotoAndPlay(83);
            this._dh_mc.addFrameScript(166,this.endDH2);
         }
         TaskController_81.speek3();
      }
      
      private function endDH2() : void
      {
         this._dh_mc.gotoAndStop(166);
         this._dh_mc.addFrameScript(166,null);
      }
      
      private function initTask81() : void
      {
         TaskController_81.initMc(this._dh_mc,this._hua_btn,this.pet_btn);
         this._hua_btn.addEventListener(MouseEvent.CLICK,this.clickHuaHandler);
         this.pet_btn.addEventListener(MouseEvent.CLICK,this.clickPetHandler);
         this.pet_btn.visible = false;
         this._hua_btn.visible = false;
         if(TasksManager.getTaskStatus(TaskController_81.TASK_ID) != TasksManager.ALR_ACCEPT)
         {
            return;
         }
         TasksManager.getProStatusList(TaskController_81.TASK_ID,function(arr:Array):void
         {
            if(!arr[0])
            {
               _dh_mc.gotoAndStop(1);
               TaskController_81.playCartoon0();
            }
            else if(Boolean(arr[0]) && !arr[1])
            {
               _dh_mc.gotoAndStop(40);
               _hua_btn.visible = true;
            }
            else if(Boolean(arr[1]) && !arr[2])
            {
               TaskController_81.addLisPetF();
               _dh_mc.gotoAndStop(81);
            }
            else if(Boolean(arr[2]) && !arr[3])
            {
               pet_btn.visible = true;
               _dh_mc.gotoAndStop(81);
            }
         });
      }
      
      private function clickLongHandler(e:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(TaskController_79.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            TaskController_79.clickHuMo();
         }
         else
         {
            FightInviteManager.fightWithBoss("哈莫雷特");
         }
      }
      
      private function onMarkClickHandler(e:MouseEvent) : void
      {
         NpcTipDialog.showAnswer("咦？你这是想进入尼古尔水帘吗？这里……这里可大有名堂啊！你想知道吗？",function():void
         {
            NpcTipDialog.show("肖恩老师说这里有很多很多不可思议的事情哦！听说，尼古尔水帘本是一个混沌、逻辑扭曲的半存在地带，这里还充满了称为乙太的原始物质呐！",function():void
            {
               NpcTipDialog.show("那个什么什么的原始物质应该存在着剧毒哦！肖恩老师说了，只有在我们<font color=\'#ff0000\'>超能NoNo</font>的保护下才可以安全进入！那个帘洞里还有……还有什么呢？你自己去看吧！",null,NpcTipDialog.NONO);
            },NpcTipDialog.NONO);
         },null,NpcTipDialog.NONO);
      }
      
      public function url() : void
      {
         var r:VipSession = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
         {
         });
         r.getSession();
      }
      
      override public function destroy() : void
      {
         if(Boolean(SuperNonoIndex._timer1))
         {
            SuperNonoIndex._timer1.stop();
            SuperNonoIndex._timer1 = null;
         }
      }
   }
}

