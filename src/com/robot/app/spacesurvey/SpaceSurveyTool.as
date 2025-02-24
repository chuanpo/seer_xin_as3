package com.robot.app.spacesurvey
{
   import com.robot.app.task.control.TaskController_37;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.utils.Dictionary;
   import org.taomee.utils.DisplayUtil;
   
   public class SpaceSurveyTool extends Sprite
   {
      private static var _instance:SpaceSurveyTool;
      
      private const PATH:String = "module/surveyPole/surveyPole.swf";
      
      private var mainMC:MovieClip;
      
      private var _surveyPoleBtn:SimpleButton;
      
      private var _spaceName:String;
      
      private var nonoSuit:MovieClip;
      
      private var normalNonoSound:Sound;
      
      private var superNonoSound:Sound;
      
      private var sc1:SoundChannel;
      
      private var dict:Dictionary = new Dictionary();
      
      public function SpaceSurveyTool()
      {
         super();
         this.dict["10"] = new Point(243,384);
         this.dict["105"] = new Point(296,368);
         this.dict["15"] = new Point(405,317);
         this.dict["20"] = new Point(492,434);
         this.dict["25"] = new Point(371,206);
         this.dict["30"] = new Point(605,462);
         this.dict["40"] = new Point(473,422);
         this.dict["47"] = new Point(450,483);
         this.dict["51"] = new Point(180,470);
         this.dict["54"] = new Point(445,310);
      }
      
      public static function getInstance() : SpaceSurveyTool
      {
         _instance = new SpaceSurveyTool();
         return _instance;
      }
      
      public function hide() : void
      {
         if(Boolean(this.mainMC))
         {
            this.mainMC.removeEventListener(MouseEvent.CLICK,this.onPoleBtnClickHandler);
            this.mainMC.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler("*"));
         }
         if(Boolean(this.nonoSuit))
         {
            this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
         }
         DisplayUtil.removeForParent(_instance);
         _instance = null;
      }
      
      public function show(str:String) : void
      {
         this._spaceName = str;
         if(TasksManager.getTaskStatus(TaskController_37.TASK_ID) == TasksManager.ALR_ACCEPT)
         {
            NonoManager.addEventListener(NonoEvent.GET_INFO,function(e:NonoEvent):void
            {
               NonoManager.removeEventListener(NonoEvent.GET_INFO,arguments.callee);
               if(Boolean(NonoManager.info.func[7]))
               {
                  loadUI();
               }
            });
            NonoManager.getInfo();
         }
      }
      
      private function loadUI() : void
      {
         var url:String = ClientConfig.getResPath(this.PATH);
         var mcloader:MCLoader = new MCLoader(url,LevelManager.appLevel,1,"正在加载测绘标杆");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         mcloader.doLoad();
      }
      
      private function onLoadSuccess(event:MCLoadEvent) : void
      {
         var mcloader:MCLoader = event.currentTarget as MCLoader;
         mcloader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadSuccess);
         var soundcls1:Class = event.getApplicationDomain().getDefinition("normalNonoSound") as Class;
         this.normalNonoSound = new soundcls1() as Sound;
         var soundcls2:Class = event.getApplicationDomain().getDefinition("superNonoSound") as Class;
         this.superNonoSound = new soundcls2() as Sound;
         var cls:Class = event.getApplicationDomain().getDefinition("mainUI") as Class;
         this.mainMC = new cls() as MovieClip;
         this.mainMC.scaleX = 0.7;
         this.mainMC.scaleY = 0.7;
         this._surveyPoleBtn = this.mainMC["surveyPoleBtn"];
         mcloader.clear();
         this.init();
      }
      
      private function init() : void
      {
         var p:Point = this.dict[MainManager.actorInfo.mapID.toString()];
         trace(p);
         this.x = p.x;
         this.y = p.y;
         this.addChild(this.mainMC);
         MapManager.currentMap.depthLevel.addChild(_instance);
         trace(MapManager.currentMap.id);
         this.mainMC.addEventListener(MouseEvent.CLICK,this.onPoleBtnClickHandler);
      }
      
      private function onPoleBtnClickHandler(event:MouseEvent) : void
      {
         if(Boolean(MainManager.actorModel.nono))
         {
            if(!NonoManager.info.func[7])
            {
               Alarm.show("你的NoNo还没有装载<font color=\'#ff0000\'>星球测绘芯片</font>哦！！");
               return;
            }
            NpcTipDialog.showAnswer("这是专业的星球测绘工具，你要立即开始星球勘察么？",function():void
            {
               MainManager.actorModel.hideNono();
               LevelManager.closeMouseEvent();
               if(NonoManager.info.superNono)
               {
                  mainMC.gotoAndStop(3);
                  superNonoSound.play(0,0);
                  mainMC.addEventListener(Event.ENTER_FRAME,onFrameHandler("superNono"));
               }
               else
               {
                  mainMC.gotoAndStop(2);
                  normalNonoSound.play(0,0);
                  mainMC.addEventListener(Event.ENTER_FRAME,onFrameHandler("normalNono"));
               }
            },null,NpcTipDialog.IRIS);
            LevelManager.closeMouseEvent();
            return;
         }
         Alarm.show("带上你的NoNo试试哦！");
      }
      
      private function onFrameHandler(mcName:String) : Function
      {
         var func:Function;
         trace("on...");
         func = function(e:Event):void
         {
            var colorTrans:ColorTransform = null;
            if(Boolean(mainMC.getChildByName(mcName)))
            {
               nonoSuit = (mainMC.getChildByName(mcName) as MovieClip).getChildByName("nonoSuit") as MovieClip;
               colorTrans = nonoSuit.transform.colorTransform;
               colorTrans.color = MainManager.actorInfo.nonoColor;
               nonoSuit.transform.colorTransform = colorTrans;
               nonoSuit.addEventListener(Event.ENTER_FRAME,onNonoSuitFrameHandler);
               mainMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
            }
            var func:Function = arguments.callee as Function;
         };
         return func;
      }
      
      private function onNonoSuitFrameHandler(event:Event) : void
      {
         var i:uint = 0;
         if(this.nonoSuit.currentFrame == this.nonoSuit.totalFrames)
         {
            LevelManager.openMouseEvent();
            this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
            this.nonoSuit = null;
            this.mainMC.gotoAndStop(1);
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
            for(i = 0; i < 10; i++)
            {
               trace(TasksXMLInfo.getProName(TaskController_37.TASK_ID,i));
               if(TasksXMLInfo.getProName(TaskController_37.TASK_ID,i) == this._spaceName)
               {
                  TasksManager.getProStatus(TaskController_37.TASK_ID,i,function(b:Boolean):void
                  {
                     if(!b)
                     {
                        TasksManager.setProStatus(TaskController_37.TASK_ID,i,true,function():void
                        {
                        });
                     }
                  });
                  SpaceSurveyResultController.show(this._spaceName);
                  break;
               }
            }
            LevelManager.openMouseEvent();
         }
      }
   }
}

