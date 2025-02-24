package com.robot.app.mapProcess
{
   import com.robot.app.control.FollowController;
   import com.robot.app.task.control.TaskController_91;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.animate.AnimateManager;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcDialog;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_63 extends BaseMapProcess
   {
      private var gelinMC:MovieClip;
      
      private var buluMC:MovieClip;
      
      private var gbMovie:MovieClip;
      
      private var bridgeMC:MovieClip;
      
      private var stoneMC:MovieClip;
      
      private var jingyuanMC:MovieClip;
      
      private var headID:uint = 0;
      
      public function MapProcess_63()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.initTask_91();
      }
      
      private function initTask_91() : void
      {
         this.gelinMC = conLevel["gelinMC"];
         this.gelinMC.buttonMode = true;
         this.gelinMC.addEventListener(MouseEvent.CLICK,this.onClickGelin);
         this.buluMC = conLevel["buluMC"];
         this.gelinMC.buttonMode = true;
         this.buluMC.addEventListener(MouseEvent.CLICK,this.onClickBulu);
         this.gbMovie = animatorLevel["gbMovie"];
         this.gbMovie.gotoAndStop(1);
         this.bridgeMC = animatorLevel["bridgeMC"];
         this.bridgeMC.gotoAndStop(1);
         this.stoneMC = animatorLevel["stoneMC"];
         this.stoneMC.visible = false;
         this.stoneMC.gotoAndStop(1);
         this.jingyuanMC = conLevel["jingyuanMC"];
         if(TasksManager.getTaskStatus(91) == TasksManager.COMPLETE)
         {
            DisplayUtil.removeForParent(this.gbMovie);
            this.stoneMC.visible = true;
            this.gelinMC.buttonMode = false;
            this.gelinMC.removeEventListener(MouseEvent.CLICK,this.onClickGelin);
            this.gelinMC.buttonMode = false;
            this.buluMC.removeEventListener(MouseEvent.CLICK,this.onClickBulu);
            return;
         }
         if(TasksManager.getTaskStatus(91) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(91,function(arr:Array):void
            {
               if(!arr[0])
               {
                  buluMC.buttonMode = false;
                  buluMC.removeEventListener(MouseEvent.CLICK,onClickBulu);
                  AimatController.addEventListener(AimatEvent.PLAY_END,shotBulu);
               }
               if(Boolean(arr[0]) && !arr[1])
               {
                  gbMovie.gotoAndStop(2);
                  buluMC.buttonMode = true;
                  buluMC.addEventListener(MouseEvent.CLICK,onHelpBulu);
               }
               if(Boolean(arr[1]) && !arr[2])
               {
                  gbMovie.gotoAndStop(4);
                  buluMC.buttonMode = true;
                  buluMC.addEventListener(MouseEvent.CLICK,onRemoveBulu);
               }
               if(Boolean(arr[2]) && !arr[3])
               {
                  DisplayUtil.removeForParent(gbMovie);
                  stoneMC.visible = true;
                  stoneMC.gotoAndStop(3);
                  jingyuanMC.buttonMode = true;
                  jingyuanMC.addEventListener(MouseEvent.CLICK,getJingyuan);
               }
            });
         }
      }
      
      private function onClickBulu(evt:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(91) == TasksManager.UN_ACCEPT)
         {
            NpcDialog.show(NPC.BULU,["..................."],["布鲁到底怎么了？先去问问格林吧！"]);
         }
      }
      
      private function onClickGelin(evt:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(91) == TasksManager.ALR_ACCEPT)
         {
            NpcDialog.show(NPC.GELIN,["拜托你！拜托你！救救我的好朋友吧！#4"],["布鲁一定会没事！"]);
         }
         else
         {
            NpcDialog.show(NPC.GELIN,["#4呜呜……怎么办？怎么办？布鲁好像因为长期在沙漠中缺水而昏倒了！怎么办？你能救救布鲁吗？拜托你！"],["快快！我想到办法了！","你先别急！让我想想办法……"],[function():void
            {
               NpcDialog.show(NPC.SEER,["缺水……缺水……你说我用0xff0000高压水枪0xffffff灌输一点水给布鲁，它会不会好一点呢？#7"],["不管这么多了！先试试吧！"],[function():void
               {
                  TasksManager.accept(91,function(b:Boolean):void
                  {
                     if(b)
                     {
                        TaskController_91.showPanel();
                     }
                  });
                  buluMC.buttonMode = false;
                  buluMC.removeEventListener(MouseEvent.CLICK,onClickBulu);
                  AimatController.addEventListener(AimatEvent.PLAY_END,shotBulu);
               }]);
            }]);
         }
      }
      
      private function shotBulu(evt:AimatEvent) : void
      {
         var id:uint = 0;
         if(evt.info.userID != MainManager.actorID)
         {
            return;
         }
         for each(id in MainManager.actorInfo.clothIDs)
         {
            if(ItemXMLInfo.getType(id) == "head")
            {
               this.headID = id;
            }
         }
         if(this.headID == 100052)
         {
            if(this.buluMC.hitTestPoint(evt.info.endPos.x,evt.info.endPos.y))
            {
               AimatController.removeEventListener(AimatEvent.PLAY_END,this.shotBulu);
               this.gbMovie.gotoAndStop(2);
               NpcDialog.show(NPC.SEER,["哈哈！#1布鲁似乎有点起色了！我这就带着我的0xff0000水系精灵0xffffff，用它的技能帮助布鲁恢复！！！"],["我这就把水系精灵带在身边！"],[function():void
               {
                  TasksManager.complete(91,0,null,true);
                  buluMC.buttonMode = true;
                  buluMC.addEventListener(MouseEvent.CLICK,onHelpBulu);
               }]);
            }
         }
         else
         {
            NpcDialog.show(NPC.SEER,["咦？#7怎么没有用？哎呀！我装备的不是0xff0000高压水枪0xffffff！（高压水枪可以在机械室领取到哦）"],["快去机械室领取"]);
         }
      }
      
      private function onHelpBulu(evt:MouseEvent) : void
      {
         var petIsWrong:Function = null;
         var hasPet:Function = null;
         var noPet:Function = null;
         petIsWrong = function():void
         {
            NpcDialog.show(NPC.GELIN,["喂！你没有把0xff0000水系精灵0xffffff带在身边啦！快点救救布鲁吧……"],["这回一定把水系精灵带在身边"]);
         };
         hasPet = function():void
         {
            buluMC.buttonMode = false;
            buluMC.removeEventListener(MouseEvent.CLICK,onHelpBulu);
            AnimateManager.playMcAnimate(gbMovie,3,"mc3",function():void
            {
               NpcDialog.show(NPC.GELIN,["好呀！！！好呀！！！布鲁似乎有点起色了！布鲁有救咯！布鲁有救咯！#8"],["我会再加把劲的!"],[function():void
               {
                  NpcDialog.show(NPC.SEER,["哇！#8布鲁看起来有点气色咯!不对！现在还不是高兴时候呐!我这就继续对着布鲁灌输水！布鲁你也要加油啊!"],["加油加油!我们一起加油！！"],[function():void
                  {
                     AnimateManager.playMcAnimate(gbMovie,4,"mc4",function():void
                     {
                        NpcDialog.show(NPC.SEER,["不要……不要再喷水了！你都已经没力气了！#2相信我，我一定会想到其他办法的！你先好好休息下吧！"],["我一定能够想到其他办法的！"],[function():void
                        {
                           NpcDialog.show(NPC.SEER,["缺水……水……对啦！布鲁不是生活在水里嘛！如果把它放入水里这是不是会好的快些？"],["不管怎么样，我都要试试！"],[function():void
                           {
                              TasksManager.complete(91,1,null,true);
                              buluMC.buttonMode = true;
                              buluMC.addEventListener(MouseEvent.CLICK,onRemoveBulu);
                           }]);
                        }]);
                     });
                  }]);
               }]);
            });
         };
         noPet = function():void
         {
            NpcDialog.show(NPC.SEER,["哎呀！你看我这个记性……应该带上水系精灵啊！快快……"],["这回一定把水系精灵带在身边"]);
         };
         FollowController.followPet(petIsWrong,null,null,"水",hasPet,noPet);
      }
      
      private function onRemoveBulu(evt:MouseEvent) : void
      {
         var nick:String = null;
         var url:String = null;
         this.gelinMC.buttonMode = false;
         this.gelinMC.removeEventListener(MouseEvent.CLICK,this.onClickGelin);
         this.buluMC.buttonMode = false;
         this.buluMC.removeEventListener(MouseEvent.CLICK,this.onRemoveBulu);
         MainManager.actorModel.visible = false;
         nick = MainManager.actorInfo.nick;
         url = "resource/bounsMovie/buandgelin.swf";
         AnimateManager.playMcAnimate(this.gbMovie,5,"mc5",function():void
         {
            MainManager.actorModel.visible = true;
            NpcDialog.show(NPC.GELIN,["你在搞什么啊！#5我的好朋友布鲁呢？它去哪里了？它到底怎么了！你干嘛把它放入水里？它现在去哪里了？？？？你还我布鲁！"],["我只是想要救它！没想到……"],[function():void
            {
               NpcDialog.show(NPC.SEER,["都怪我自作聪明……布鲁……布鲁……对不起……#4"],["都是我太自作聪明了！都是我！"],[function():void
               {
                  AnimateManager.playFullScreenAnimate(url,function():void
                  {
                     gbMovie.gotoAndStop(6);
                     NpcDialog.show(NPC.SEER,["哈哈哈！哈哈！#8布鲁复活咯！布鲁复活咯！太棒了！"],["布鲁复活咯！！！"],[function():void
                     {
                        NpcDialog.show(NPC.BULUGELIN,["嘻嘻……" + nick + "，谢谢你！#6要不是你，我们两个也没机会再次重逢了！其实我们当初是为了比赛谁能先找到最美丽的月影湖而分散的，没想到竟然都找到了这里！O(∩_∩)O"],["看到你们在一起我就很开心了！"],[function():void
                        {
                           NpcDialog.show(NPC.SEER,["哈哈……没事！没事！看到布鲁没事，看到你们能够重逢！我已经很开心啦！#8嘿嘿……"],["看到它们重逢的画面我真激动！"],[function():void
                           {
                              NpcDialog.show(NPC.BULUGELIN,[nick + "，我们要走咯！我们两个约定好一起去更多美丽的地方旅行咯！这次我们不会分开了！你可要珍惜你身边的好朋友哦！不能也因为一点小事就分开啦！我们该走了，有机会的话再见吧……"],["我一定会珍惜我身边的朋友！"],[function():void
                              {
                                 DisplayUtil.removeForParent(gbMovie);
                                 AnimateManager.playMcAnimate(bridgeMC,2,"mc2",function():void
                                 {
                                    bridgeMC.gotoAndStop(1);
                                    stoneMC.visible = true;
                                    AnimateManager.playMcAnimate(stoneMC,2,"mc2",function():void
                                    {
                                       TasksManager.complete(91,2,null,true);
                                       stoneMC.gotoAndStop(3);
                                       jingyuanMC.buttonMode = true;
                                       jingyuanMC.addEventListener(MouseEvent.CLICK,getJingyuan);
                                    });
                                 });
                              }]);
                           }]);
                        }]);
                     }]);
                  });
               }]);
            }]);
         });
      }
      
      private function getJingyuan(evt:MouseEvent) : void
      {
         this.jingyuanMC.buttonMode = false;
         this.jingyuanMC.removeEventListener(MouseEvent.CLICK,this.getJingyuan);
         NpcDialog.show(NPC.SEER,["咦？？这个是什么？真的有东西在动啊！！！#7"],["不怕！不怕！我再认真看看！"],[function():void
         {
            NpcDialog.show(NPC.SEER,["啊!这形状，这样子……似乎是……精元？精灵的精元？哈哈哈！真的是精灵的精元哦！我这就把你带回基地，让NoNo来孵化你！小东西，你长什么样子呢？"],["小东西，我真想看看孵化后的你……"],[function():void
            {
               TasksManager.complete(91,3);
               stoneMC.gotoAndStop(1);
            }]);
         }]);
      }
      
      override public function destroy() : void
      {
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.shotBulu);
      }
   }
}

