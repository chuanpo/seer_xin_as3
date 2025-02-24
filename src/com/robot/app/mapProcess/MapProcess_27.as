package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.control.TaskController_93;
   import com.robot.core.animate.AnimateManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_27 extends BaseMapProcess
   {
      private var _bird:MovieClip;
      
      private var _answerPanel:AppModel;
      
      private var _isShow:Boolean = true;
      
      private var _musicMc:MovieClip;
      
      private var allMcMovie:MovieClip;
      
      private var isShow:Boolean = true;
      
      public function MapProcess_27()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._bird = conLevel.getChildByName("birdMc") as MovieClip;
         this._bird.buttonMode = true;
         this._bird.addEventListener(MouseEvent.CLICK,this.onBirdClick);
         this._bird.gotoAndStop(1);
         ToolTipManager.add(conLevel["door_mc"],"入仓身份认证");
         this._musicMc = conLevel.getChildByName("musicMc") as MovieClip;
         this._musicMc.mouseEnabled = false;
         this._musicMc.mouseChildren = false;
         this.allMcMovie = conLevel["allMovie"];
         this.allMcMovie.visible = false;
         conLevel["ruleMc"].visible = false;
         conLevel["ruleMc"].gotoAndStop(1);
         this.chack();
         if(TasksManager.getTaskStatus(93) == TasksManager.ALR_ACCEPT)
         {
            this._bird.visible = false;
            this.allMcMovie.visible = true;
            this.allMcMovie.gotoAndStop(6);
            TasksManager.getProStatusList(93,function(arr:Array):void
            {
               if(!arr[0])
               {
                  NpcDialog.show(NPC.TIYASI,["我说了！离开！#5！！我不管你是哪里来的！离开我的地盘！别碰我的蛋！#5#5#5"],["这到底是怎么一回事？咦？旁边的是？"],[function():void
                  {
                     NpcDialog.show(NPC.NEWFISH,["咕哒……咕哒……咕哒哒……咕……哒哒哒哒哒！！！！！#5#5"],["天啊！它这说的是什么意思？到底怎么了？"],[function():void
                     {
                        trace("场景动画");
                        trace("提亚斯技能飞空俯冲把浮空苗的首领撞倒在地上（近距离攻击）");
                        AnimateManager.playMcAnimate(allMcMovie,1,"birdMc",function():void
                        {
                           tasksControl();
                           conLevel["door_0"].mouseEnabled = false;
                           allMcMovie["fishMC"].buttonMode = true;
                           allMcMovie["fishMC"].addEventListener(MouseEvent.CLICK,fishSpeak);
                        });
                     }]);
                  }]);
               }
               else if(Boolean(arr[0]) && !arr[1])
               {
                  AnimateManager.playMcAnimate(allMcMovie,1,"birdMc",function():void
                  {
                     allMcMovie["fishMC"].buttonMode = true;
                     conLevel["door_0"].mouseEnabled = false;
                     allMcMovie["fishMC"].addEventListener(MouseEvent.CLICK,fishSpeak);
                  });
               }
               else if(Boolean(arr[1]) && !arr[2])
               {
                  MainManager.actorModel.visible = false;
                  LevelManager.closeMouseEvent();
                  AnimateManager.playMcAnimate(allMcMovie,3,"birdMc",function():void
                  {
                     allMcMovie["birdMc"].buttonMode = true;
                     LevelManager.openMouseEvent();
                     allMcMovie["birdMc"].addEventListener(MouseEvent.CLICK,baohuBird);
                  });
               }
               else if(Boolean(arr[2]) && !arr[3])
               {
                  allMcMovie.visible = false;
               }
            });
         }
      }
      
      private function tasksControl() : void
      {
         TaskController_93.highTask();
      }
      
      private function fishSpeak(e:MouseEvent) : void
      {
         conLevel["door_0"].mouseEnabled = true;
         TasksManager.getProStatusList(93,function(arr:Array):void
         {
            if(Boolean(arr[0]) && !arr[1])
            {
               MainManager.actorModel.visible = false;
               LevelManager.closeMouseEvent();
               trace("播放场景动画，赛尔冲到了那个精灵前面，被提亚斯的魔能暴风打到了，狠狠的摔倒在地上");
               AnimateManager.playMcAnimate(allMcMovie,2,"seerMC",function():void
               {
                  AnimateManager.playFullScreenAnimate("resource/bounsMovie/openEye.swf",function():void
                  {
                     NpcDialog.show(NPC.NEWFISH,["#2咕哒！咕咕！咕哒咕哒！咕咕咕……"],["不……不要再打了……"],[function():void
                     {
                        AnimateManager.playMcAnimate(allMcMovie,3,"seerMC",function():void
                        {
                           NpcDialog.show(NPC.SEER,["提……提亚斯……"],["我不能眼睁睁看着精灵在我面前受伤！"],[function():void
                           {
                              TasksManager.complete(93,1,null,true);
                              LevelManager.openMouseEvent();
                              allMcMovie["birdMc"].addEventListener(MouseEvent.CLICK,baohuBird);
                           }]);
                        });
                     }]);
                  });
               });
            }
         });
      }
      
      private function baohuBird(e:MouseEvent) : void
      {
         trace("播放全屏动画，进入提亚斯对战画面");
         AnimateManager.playFullScreenAnimate("resource/bounsMovie/fishFight.swf",function():void
         {
            trace("播放完全屏动画，直接返回场景继续场景动画");
            AnimateManager.playMcAnimate(allMcMovie,4,"seerMC",function():void
            {
               NpcDialog.show(NPC.TIYASI,["我这都做了些什么……我为什么就是不能控制我容易暴躁的性格呢！！我……#2"],["精……灵……伙伴……"],[function():void
               {
                  NpcDialog.show(NPC.NEWFISH,["咕咕咕咕#2#2……咕咕咕咕#4……"],["别……别哭！我……我没事！嘿嘿"],[function():void
                  {
                     NpcDialog.show(NPC.SEER,["我……我想救我的办法只有一个！那就是你们和好，不再为了地盘的事情争吵不休了……要不我可就要……"],["真希望它们能和好！"],[function():void
                     {
                        trace("播放场景动画，浮空鱼朝提亚斯看看 两个人表示互相能够接受彼此 这个时候赛尔突然从地板上跳起来 很开心的样子");
                        AnimateManager.playMcAnimate(allMcMovie,5,"seerMC",function():void
                        {
                           NpcDialog.show(NPC.SEER,["哈哈#8！我可是机械小赛尔，我才没这么容易被击倒呢！受伤是小，希望你们和好是真！对了提亚斯，那个精灵叫什么？怎么会到云霄星来呀？"],["那家伙长的还挺有意思的！"],[function():void
                           {
                              NpcDialog.show(NPC.TIYASI,["首领被称为浮空鱼，它们原本居住的地方因为受到了其他种族精灵的侵袭，所有的食物也相近频临绝种，所以它们只能被迫迁徙……我前面是怕它们来抢我的蛋……我才#2"],["没事啦！都过去了！我想它们也不会计较的！"],[function():void
                              {
                                 NpcDialog.show(NPC.NEWFISH,["咕咕咕……咕咕……咕嘟嘟……嘟嘟！！#1#1#8"],["它总是咕咕咕的说什么呢……不管了！和好就好！"],[function():void
                                 {
                                    TasksManager.complete(93,2,null,true);
                                    MainManager.actorModel.visible = true;
                                    allMcMovie.visible = false;
                                 }]);
                              }]);
                           }]);
                        });
                     }]);
                  }]);
               }]);
            });
         });
      }
      
      private function chack() : void
      {
         if(TasksManager.getTaskStatus(305) == TasksManager.COMPLETE)
         {
            this._bird.gotoAndStop(this._bird.totalFrames);
         }
      }
      
      override public function destroy() : void
      {
         ToolTipManager.remove(conLevel["door_mc"]);
         this._bird.removeEventListener(MouseEvent.CLICK,this.onBirdClick);
         this._bird = null;
         if(Boolean(this._answerPanel))
         {
            this._answerPanel.sharedEvents.removeEventListener(Event.CLOSE,this.onAnswerPanelClose);
            this._answerPanel.destroy();
            this._answerPanel = null;
         }
         this._musicMc.removeEventListener(MouseEvent.CLICK,this.onMusicClick);
         this._musicMc = null;
      }
      
      public function showAnswerHandler() : void
      {
         if(this._isShow)
         {
            if(this._answerPanel == null)
            {
               this._answerPanel = new AppModel(ClientConfig.getAppModule("AnswerQuestionPanel"),"正在打开门禁系统");
               this._answerPanel.setup();
               this._answerPanel.sharedEvents.addEventListener(Event.CLOSE,this.onAnswerPanelClose);
            }
            this._answerPanel.show();
         }
      }
      
      private function onAnswerPanelClose(e:Event) : void
      {
         this._answerPanel.sharedEvents.removeEventListener(Event.CLOSE,this.onAnswerPanelClose);
         this._answerPanel.destroy();
         this._answerPanel = null;
         conLevel["dis_mc"].gotoAndPlay(2);
         this._isShow = false;
      }
      
      private function onBirdClick(e:MouseEvent) : void
      {
         this.onBirdHit();
      }
      
      private function onMusicClick(e:MouseEvent) : void
      {
         if(this._musicMc.currentFrame == 1)
         {
            this._musicMc.gotoAndStop(2);
            this._musicMc.buttonMode = true;
         }
      }
      
      public function onBirdHit() : void
      {
         if(this._bird.currentFrame == 1)
         {
            this._bird.gotoAndPlay(2);
            return;
         }
         if(TasksManager.getTaskStatus(93) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(93,function(arr:Array):void
            {
               if(!(Boolean(arr[1]) && !arr[2]))
               {
                  if(Boolean(arr[2]) && !arr[3])
                  {
                     trace("去提交任务吧");
                  }
               }
            });
         }
         else
         {
            FightInviteManager.fightWithBoss("提亚斯");
         }
      }
   }
}

