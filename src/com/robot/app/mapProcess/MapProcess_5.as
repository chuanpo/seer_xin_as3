package com.robot.app.mapProcess
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.app.buyPetProps.BuyPetPropsController;
   import com.robot.app.control.SpriteFusionController;
   import com.robot.app.evolvePet.EvolvePetController;
   import com.robot.app.help.HelpManager;
   import com.robot.app.newspaper.ContributeAlert;
   import com.robot.app.task.books.MonsterBook;
   import com.robot.app.task.control.TaskController_95;
   import com.robot.app.task.control.TaskController_98;
   import com.robot.app.task.noviceGuide.GuideTaskModel;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.weekMonster.WeekMonsterMain;
   import com.robot.core.CommandID;
   import com.robot.core.animate.AnimateManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.TempPetManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.book.BookId;
   import com.robot.core.manager.book.BookManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcController;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_5 extends BaseMapProcess
   {
      public static var doctorNPC:MovieClip;
      
      private var tBtn:MovieClip;
      
      private var npcMc:MovieClip;
      
      private var btn:Sprite;
      
      private var monsterBtn:SimpleButton;
      
      private var glowMC:MovieClip;
      
      private var _dbtn_2:MovieClip;
      
      private var _collectBtn:MovieClip;
      
      private var _petCollectPanel:AppModel;
      
      private var _petSkillBtn:MovieClip;
      
      private var _petSelectPanel:AppModel;
      
      private var tgBtn:SimpleButton;
      
      private var curIndex:uint = 1;
      
      private var maxNum:uint = 2;
      
      private var _infoA:Array;
      
      private var _petColltectPanel:AppModel;
      
      private var yangHuMc:SimpleButton;
      
      private var _so:SharedObject;
      
      private var petbook_btn:MovieClip;
      
      private var wbMc:MovieClip;
      
      private var mbox:DialogBox;
      
      private var docPlayGrapeMC:MovieClip;
      
      private const PATH:String = "com.robot.app.task.control";
      
      public function MapProcess_5()
      {
         super();
      }
      
      override protected function init() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_LAS_EGG,this.onGetLAS);
         this.curIndex = 1;
         this.maxNum = 2;
         this._infoA = new Array();
         ToolTipManager.add(conLevel["evDoorMC"],"精灵进化仓");
         doctorNPC = conLevel["npcDoctor"];
         doctorNPC.visible = false;
         this.npcMc = UIManager.getMovieClip("doctor");
         this.monsterBtn = conLevel["monsterBtn"] as SimpleButton;
         this.glowMC = conLevel["glowMC"] as MovieClip;
         this._so = SOManager.getUserSO(SOManager.Is_Readed_MonsterBook);
         if(!this._so.data.hasOwnProperty("isShow"))
         {
            this.glowMC.visible = true;
            this.glowMC.play();
         }
         else if(!this._so.data["isShow"] == true)
         {
            this.glowMC.visible = true;
            this.glowMC.play();
         }
         else
         {
            this.glowMC.visible = false;
         }
         if(TasksManager.getTaskStatus(98) == TasksManager.COMPLETE)
         {
            conLevel["nibu_npc"].visible = false;
         }
         if(TasksManager.taskList[1] != 3 && GuideTaskModel.bTaskDoctor)
         {
            if(GuideTaskModel.bReadMonBook)
            {
               return;
            }
            this.glowMC.visible = true;
            this.glowMC.play();
         }
         ToolTipManager.add(this.monsterBtn,"精灵手册");
         this.monsterBtn.addEventListener(MouseEvent.CLICK,this.showMonsterBook);
         this._dbtn_2 = conLevel["petPropMC"] as MovieClip;
         ToolTipManager.add(this._dbtn_2,"道具购买");
         this._collectBtn = conLevel["collectBtn"];
         this._collectBtn.addEventListener(MouseEvent.CLICK,this.onCollect);
         ToolTipManager.add(this._collectBtn,"精灵收集奖励");
         this.tgBtn = conLevel["tgBtn"];
         ToolTipManager.add(this.tgBtn,"给博士写信");
         this.tgBtn.addEventListener(MouseEvent.CLICK,this.tgHandler);
         this._petSkillBtn = conLevel.getChildByName("petSkillBtn") as MovieClip;
         this._petSkillBtn.addEventListener(MouseEvent.CLICK,this.onDoorClick);
         ToolTipManager.add(this._petSkillBtn,"技能唤醒仪");
         ToolTipManager.add(conLevel["newMonrMC"],"精灵探测仪");
         this.wbMc = conLevel["hitWbMC"];
         this.wbMc.addEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.addEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         ToolTipManager.add(conLevel["fusionMC"],"精灵融合转生仓");
         this.petbook_btn = conLevel["petBook_btn"];
         ToolTipManager.add(this.petbook_btn,"精灵融合手册");
         this.petbook_btn.addEventListener(MouseEvent.CLICK,this.clickPetBookHandler);
         this.initTask_95();
      }
      
      private function clickPetBookHandler(e:MouseEvent) : void
      {
         BookManager.show(BookId.BOOK_1);
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
      
      public function showWBTask() : void
      {
         HelpManager.show(0);
      }
      
      private function tgHandler(event:MouseEvent) : void
      {
         ContributeAlert.show(ContributeAlert.DOCTOR_TYPE);
      }
      
      private function clickYangHuHandler(e:MouseEvent) : void
      {
      }
      
      public function evolvePet() : void
      {
         EvolvePetController.show();
      }
      
      public function showWbAction() : void
      {
         var mc:MovieClip = conLevel["wbNpc"] as MovieClip;
         mc.gotoAndPlay(2);
      }
      
      override public function destroy() : void
      {
         this.petbook_btn.removeEventListener(MouseEvent.CLICK,this.clickPetBookHandler);
         this.petbook_btn = null;
         BookManager.destroy();
         this._so = null;
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OVER,this.wbmcOverHandler);
         this.wbMc.removeEventListener(MouseEvent.MOUSE_OUT,this.wbmcOUTHandler);
         this.wbMc = null;
         this.mbox = null;
         ToolTipManager.remove(this._collectBtn);
         this.tgBtn.removeEventListener(MouseEvent.CLICK,this.tgHandler);
         ToolTipManager.remove(this.tgBtn);
         this.tgBtn = null;
         ToolTipManager.remove(conLevel["evDoorMC"]);
         ToolTipManager.remove(this._dbtn_2);
         ToolTipManager.remove(this.monsterBtn);
         this.monsterBtn.removeEventListener(MouseEvent.CLICK,this.showMonsterBook);
         this.glowMC = null;
         this.monsterBtn = null;
         this._collectBtn.removeEventListener(MouseEvent.CLICK,this.onCollect);
         this._collectBtn = null;
         if(Boolean(this._petCollectPanel))
         {
            this._petCollectPanel.destroy();
            this._petCollectPanel = null;
         }
         if(Boolean(this._petSelectPanel))
         {
            this._petSelectPanel.destroy();
            this._petSelectPanel = null;
         }
         if(Boolean(this._petColltectPanel))
         {
            this._petColltectPanel.destroy();
            this._petColltectPanel = null;
         }
         this._petSkillBtn.removeEventListener(MouseEvent.CLICK,this.onDoorClick);
         ToolTipManager.remove(this._petSkillBtn);
         this._petSkillBtn = null;
         SocketConnection.removeCmdListener(CommandID.GET_LAS_EGG,this.onGetLAS);
      }
      
      private function showMonsterBook(e:MouseEvent) : void
      {
         this._so.data["isShow"] = true;
         SOManager.flush(this._so);
         this.glowMC.visible = false;
         this.glowMC.stop();
         MonsterBook.loadPanel();
      }
      
      public function showPetProp() : void
      {
         BuyPetPropsController.show();
      }
      
      public function showWeekMon() : void
      {
         WeekMonsterMain.loadMonster();
      }
      
      public function getItem() : void
      {
         ItemAction.buyItem(100245,false);
      }
      
      private function onDoorClick(e:MouseEvent) : void
      {
         if(PetManager.length == 0)
         {
            Alarm.show("精灵背包里没有一只精灵");
            return;
         }
         if(this._petSelectPanel == null)
         {
            this._petSelectPanel = new AppModel(ClientConfig.getAppModule("PetSelectPanel"),"正在打开换技能唤醒面板");
            this._petSelectPanel.setup();
         }
         this._petSelectPanel.show();
      }
      
      private function onCollect(e:MouseEvent) : void
      {
         if(TasksManager.isComNoviceTask())
         {
            this.check();
         }
         else
         {
            NpcTipDialog.show("当你完成了新船员任务后再来这里看看吧。",null,NpcTipDialog.DOCTOR);
         }
      }
      
      public function check() : void
      {
         if(this.curIndex <= this.maxNum)
         {
            SocketConnection.addCmdListener(CommandID.IS_COLLECT,this.onCheckSuccessHandler);
            SocketConnection.send(CommandID.IS_COLLECT,this.curIndex);
         }
         else
         {
            this.show();
         }
      }
      
      private function onCheckSuccessHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.IS_COLLECT,this.onCheckSuccessHandler);
         var by:ByteArray = e.data as ByteArray;
         var id:uint = by.readUnsignedInt();
         var isCom:Boolean = Boolean(by.readUnsignedInt());
         this._infoA.push(isCom);
         ++this.curIndex;
         this.check();
      }
      
      private function show() : void
      {
         if(!this._petColltectPanel)
         {
            this._petColltectPanel = new AppModel(ClientConfig.getAppModule("PetCollectBoundsPanel"),"正在打开精灵收集奖励");
            this._petColltectPanel.init(this._infoA);
            this._petColltectPanel.setup();
         }
         this._petColltectPanel.show();
      }
      
      public function getPetHandler() : void
      {
         SocketConnection.send(CommandID.GET_LAS_EGG);
      }
      
      private function onGetLAS(event:SocketEvent) : void
      {
         var name:String = ItemXMLInfo.getName(400107);
         ItemInBagAlert.show(400107,1 + "个<font color=\'#ff0000\'>" + name + "</font>已经放入你的储存箱中！");
      }
      
      public function spriteFusion() : void
      {
         SpriteFusionController.show();
      }
      
      private function initTask_95() : void
      {
         this.docPlayGrapeMC = animatorLevel["docPlayGrapeMC"];
         this.docPlayGrapeMC.visible = false;
         this.docPlayGrapeMC.gotoAndStop(1);
         if(TasksManager.getTaskStatus(95) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(95,function(arr:Array):void
            {
               if(Boolean(arr[0]) && !arr[1])
               {
                  if(TaskController_95.shot_grape_complete)
                  {
                     EventManager.addEventListener(NpcController.GET_CURNPC,function(evt:Event):void
                     {
                        EventManager.removeEventListener(NpcController.GET_CURNPC,arguments.callee);
                        NpcController.curNpc.npc.npc.visible = false;
                     });
                     askShotGrape();
                  }
               }
               if(Boolean(arr[1]))
               {
                  DisplayUtil.removeForParent(docPlayGrapeMC);
               }
               if(Boolean(arr[5]) && !arr[6])
               {
                  if(TaskController_95.help_dawei_complete)
                  {
                     TaskController_95.showTaskPanel(7);
                     EventManager.addEventListener("taskPanel_7_close",showTaskPanelComp_7);
                  }
               }
            });
         }
      }
      
      private function askShotGrape() : void
      {
         this.docPlayGrapeMC.visible = true;
         if(Boolean(NpcController.curNpc))
         {
            NpcController.curNpc.npc.npc.visible = false;
         }
         TaskController_95.shot_grape_complete = false;
         NpcDialog.show(NPC.DOCTOR,["哇哦！哇哦！这是什么？快让我来看看！这个精灵为什么这么圆啊！就好像是长胡子的洋葱头？"],["这个是我们在黑色旋涡深处发现的精灵物种！"],[function():void
         {
            NpcDialog.show(NPC.DOCTOR,["我这就用精灵分析器来看看！一定能找到它的相关数据！看到它可真令我兴奋！"],["我们也很想知道关于它的信息哦！"],[function():void
            {
               TaskController_95.showTaskPanel(1);
               EventManager.addEventListener("taskPanel_1_close",showTaskPanelComp_1);
            }]);
         }]);
      }
      
      private function showTaskPanelComp_1(evt:DynamicEvent) : void
      {
         EventManager.removeEventListener("taskPanel_1_close",this.showTaskPanelComp_1);
         NpcDialog.show(NPC.DOCTOR,["嚯嚯嚯嚯！这令我更加兴奋啊！这个家伙竟然在我的精灵档案中都搜寻不到！想必大有来头啊！！！#10"],["神秘的新精灵？"],[function():void
         {
            AnimateManager.playMcAnimate(docPlayGrapeMC,2,"mc2",function():void
            {
               NpcDialog.show(NPC.LAMU,["喂喂喂！白色铁皮桶！我可告诉你了，我的老大他会中国功夫！你再靠近我！再靠近我！我就呼叫他了！我们可是有心灵感应的！"],["哇！那家伙会说话？"],[function():void
               {
                  AnimateManager.playMcAnimate(docPlayGrapeMC,3,"mc3",function():void
                  {
                     NpcDialog.show(NPC.PUTI,["哦哒哒哒哒哒！%……&%*）@！！！离*（￥&￥#远！！摩……￥尔！！%*￥&#￥……#！@！校&&……#长！#5"],["离远？摩尔校长？什么乱七八糟的呀！"],[function():void
                     {
                        NpcDialog.show(NPC.DOCTOR,["啊哈！我有办法！外星人翻译器！我去找找！我的机械锦囊里一定有这玩意……"],["外星人翻译器？"],[function():void
                        {
                           TaskController_95.showTaskPanel(2);
                           EventManager.addEventListener("taskPanel_2_close",showTaskPanelComp_2);
                        }]);
                     }]);
                  });
               }]);
            });
         }]);
      }
      
      private function showTaskPanelComp_2(evt:DynamicEvent) : void
      {
         EventManager.removeEventListener("taskPanel_2_close",this.showTaskPanelComp_2);
         NpcDialog.show(NPC.DOCTOR,["咳！它原来不是精灵啊！不过看来那个三根毛真的是遇到困难了！你们就帮帮他吧！虽然我没听懂#3……"],["恩！我们正好也要去那里找线索！"],[function():void
         {
            TasksManager.complete(95,1,null,true);
            NpcController.curNpc.npc.npc.visible = true;
            DisplayUtil.removeForParent(docPlayGrapeMC);
            TempPetManager.showTempPet(500);
         }]);
      }
      
      private function showTaskPanelComp_7(evt:DynamicEvent) : void
      {
         EventManager.removeEventListener("taskPanel_7_close",this.showTaskPanelComp_7);
         TempPetManager.hideTempPet();
         TasksManager.complete(95,6,null,true);
      }
      
      private function getNpcDialogArr(s:String) : Array
      {
         var a:Array = s.split("@");
         var dialogArr:Array = [];
         var questionArr:Array = [];
         dialogArr.push(a[0]);
         questionArr.push(a[1]);
         if(Boolean(a[2]))
         {
            questionArr.push(a[2]);
         }
         return [dialogArr,questionArr];
      }
      
      public function showNpcDialog() : void
      {
         var showStep:Function;
         var name:String = null;
         var array:Array = null;
         if(TasksManager.getTaskStatus(98) == TasksManager.UN_ACCEPT)
         {
            showStep = function():void
            {
               var reg:RegExp = null;
               var str:String = null;
               var arr:Array = null;
               var eArr:Array = null;
               if(array.length > 1)
               {
                  reg = /&[0-9]*&/;
                  str = array.shift().toString();
                  arr = getNpcDialogArr(str);
                  NpcDialog.show(NPC.NIBU,arr[0],arr[1],[function():void
                  {
                     showStep();
                  }]);
               }
               else
               {
                  eArr = getNpcDialogArr(array.shift().toString());
                  NpcDialog.show(NPC.NIBU,eArr[0],eArr[1],[function():void
                  {
                     TasksManager.accept(TaskController_98.TASK_ID,function(b:Boolean):void
                     {
                        var cls:* = undefined;
                        if(b)
                        {
                           TasksManager.setTaskStatus(TaskController_98.TASK_ID,TasksManager.ALR_ACCEPT);
                           NpcController.refreshTaskInfo();
                           cls = getDefinitionByName(PATH + "::TaskController_" + TaskController_98.TASK_ID);
                           cls.start();
                           AnimateManager.playMcAnimate(btnLevel["task98_effect"],0,"",function():void
                           {
                              btnLevel["task98_effect"].visible = false;
                              TasksManager.complete(TaskController_98.TASK_ID,0,function():void
                              {
                                 cls.showPanel();
                              });
                           });
                        }
                        else
                        {
                           Alarm.show("接受任务失败，请稍后再试！");
                        }
                     });
                  }]);
               }
            };
            name = TasksXMLInfo.getName(TaskController_98.TASK_ID);
            array = TasksXMLInfo.getTaskDes(TaskController_98.TASK_ID).split("$$");
            showStep();
         }
         else if(TasksManager.getTaskStatus(98) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatusList(TaskController_98.TASK_ID,function(arr:Array):void
            {
               var proStr:String = null;
               if(Boolean(arr[4]) && !arr[5])
               {
                  TasksManager.complete(TaskController_98.TASK_ID,5,function(b:Boolean):void
                  {
                     if(b)
                     {
                        conLevel["nibu_npc"].visible = false;
                     }
                  });
               }
               else
               {
                  proStr = TasksXMLInfo.getProDes(TaskController_98.TASK_ID);
                  arr = getNpcDialogArr(proStr);
                  NpcDialog.show(NPC.NIBU,arr[0],arr[1]);
               }
            });
         }
      }
   }
}

