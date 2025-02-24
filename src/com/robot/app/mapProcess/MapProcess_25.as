package com.robot.app.mapProcess
{
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.app.sceneInteraction.CloudFloorScene;
   import com.robot.app.spacesurvey.SpaceSurveyTool;
   import com.robot.app.task.SeerInstructor.NewInstructorContoller;
   import com.robot.app.task.control.TaskController_93;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Timer;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_25 extends BaseMapProcess
   {
      private var gasMC:MovieClip;
      
      private var type:uint;
      
      private var mainStone:MovieClip;
      
      private var _jitaMc:MovieClip;
      
      private var _maomaoArr:Array = [22,23,24];
      
      private var mcTask:MovieClip;
      
      private var str1:String = "SOS！SOS！";
      
      private var str2:String = "呀！难道是云霄星大暴动吗？";
      
      private var str3:String = "快来帮帮我们吧！哇……";
      
      private var index:Number = 0;
      
      private var _timer1:Timer;
      
      private var bigMao:MovieClip;
      
      private var maomao:MovieClip;
      
      public function MapProcess_25()
      {
         super();
      }
      
      override protected function init() : void
      {
         SpaceSurveyTool.getInstance().show("云宵星");
         this.gasMC = conLevel["gasEffectMC"];
         this.gasMC.gotoAndStop(3);
         this.mainStone = conLevel["mainStone"];
         this.mainStone.addEventListener(Event.COMPLETE,this.onMainComp);
         NewInstructorContoller.chekWaste();
         this.maomao = conLevel["hitMaoMaoMc"];
         this.mcTask = conLevel["taskMC"];
         this.maomao.buttonMode = true;
         this.maomao.addEventListener(MouseEvent.CLICK,this.taskStart);
         this.mcTask.mouseChildren = false;
         this.mcTask.mouseEnabled = false;
         this.bigMao = conLevel["bigMaomao"];
         this.bigMao.visible = false;
         this.bigMao.gotoAndStop(1);
         TasksManager.getProStatusList(97,function(arr:Array):void
         {
            if(Boolean(arr[3]) && !arr[4])
            {
               if(MapProcess_325.visiteMaomao != "visited")
               {
                  bigMao.visible = true;
                  bigMao.buttonMode = true;
                  bigMao.addEventListener(MouseEvent.CLICK,pleaseMao);
               }
            }
         });
         if(TasksManager.getTaskStatus(93) == TasksManager.COMPLETE)
         {
            this.mcTask.visible = false;
            this.maomao.visible = false;
            this.maomao.mouseChildren = false;
            this.maomao.mouseEnabled = false;
         }
         ToolTipManager.add(conLevel["hitKMC"],"云霄星高空层通道");
         ToolTipManager.add(conLevel["switchMC"],"云霄星高空层通道");
      }
      
      private function pleaseMao(e:MouseEvent) : void
      {
         NpcDialog.show(NPC.BIGMAOMAO,["哇哇哇！！！嘟嘟哒！嘟嘟哒！什么？你说你找我去开演唱会？哇卡卡卡卡！那可是毛毛的梦想！！#8#8我这就去艾迪星球！哟呼！"],["毛毛似乎太兴奋了点吧……"],[function():void
         {
            var panel:* = undefined;
            var name:* = undefined;
            bigMao.gotoAndPlay(1);
            MapProcess_325.visiteMaomao = "visited";
            bigMao.mouseChildren = false;
            bigMao.mouseEnabled = false;
            if(MapProcess_325.vistiteEva == "visited")
            {
               TasksManager.complete(97,4,null,true);
            }
            else
            {
               panel = null;
               name = "TaskPanel_97";
               if(panel)
               {
                  panel.destroy();
                  panel = null;
               }
               panel = new AppModel(ClientConfig.getTaskModule(name),"正在打开任务信息");
               panel.setup();
               panel.show();
            }
         }]);
      }
      
      private function taskStart(e:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(93) == TasksManager.UN_ACCEPT)
         {
            TaskController_93.taskSpeak();
            return;
         }
         if(TasksManager.getTaskStatus(93) == TasksManager.ALR_ACCEPT)
         {
            NpcDialog.show(NPC.MAOMAO,["喂！你刚才不是说你去云霄星高空层看看？怎么样？知道它们为什么大打出手了吗？#7"],["知道了！知道了！我这就去！"],null);
         }
         TasksManager.getProStatusList(93,function(arr:Array):void
         {
            if(Boolean(arr[2]) && !arr[3])
            {
               TasksManager.complete(93,3,null,true);
               mcTask.visible = false;
               maomao.visible = false;
               return;
            }
         });
      }
      
      private function onMainComp(event:Event) : void
      {
         DisplayUtil.removeForParent(typeLevel["areaMC"]);
         MapManager.currentMap.makeMapArray();
      }
      
      override public function destroy() : void
      {
         SpaceSurveyTool.getInstance().hide();
         CloudFloorScene.destroy();
         this.mainStone.removeEventListener(Event.COMPLETE,this.onMainComp);
         this.mainStone = null;
         this.gasMC = null;
         this._maomaoArr = null;
      }
      
      public function kettleFun() : void
      {
         CloudFloorScene.start();
      }
      
      public function clearWaste() : void
      {
         NewInstructorContoller.setWaste();
      }
      
      public function exploitGas() : void
      {
         EnergyController.exploit();
      }
   }
}

