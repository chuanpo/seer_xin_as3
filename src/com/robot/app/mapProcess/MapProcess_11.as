package com.robot.app.mapProcess
{
   import com.robot.app.task.SeerInstructor.NewInstructorContoller;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.mode.PetModel;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_11 extends BaseMapProcess
   {
      private var balkMC:MovieClip;
      
      private var clickMC:MovieClip;
      
      private var catchTimer:Timer;
      
      private var isCacthing:Boolean = false;
      
      private var isFlower:Boolean = false;
      
      public function MapProcess_11()
      {
         super();
      }
      
      override protected function init() : void
      {
         var box:DialogBox = null;
         UserManager.addActionListener(MainManager.actorID,this.onAction);
         this.balkMC = typeLevel["balkMC"];
         this.clickMC = conLevel["clickMC"];
         this.clickMC.addEventListener(MouseEvent.CLICK,this.showTip);
         if(Boolean(MainManager.actorModel.nono))
         {
            if(MainManager.actorInfo.superNono)
            {
               DisplayUtil.removeForParent(this.balkMC);
               DisplayUtil.removeForParent(this.clickMC);
               MapManager.currentMap.makeMapArray();
            }
         }
         var clothes:Array = MainManager.actorInfo.clothIDs;
         if(clothes.indexOf(100011) != -1)
         {
            DisplayUtil.removeForParent(this.balkMC);
            DisplayUtil.removeForParent(this.clickMC);
            MapManager.currentMap.makeMapArray();
         }
         NewInstructorContoller.chekWaste();
         this.catchTimer = new Timer(5 * 1000,1);
         this.catchTimer.addEventListener(TimerEvent.TIMER,this.onCatchTimer);
         if(TasksManager.getTaskStatus(403) == TasksManager.COMPLETE)
         {
            this.isFlower = true;
            conLevel["flowerMC"].gotoAndStop("live");
         }
         else
         {
            box = new DialogBox();
            box.show("好想要新鲜空气和阳光啊",0,-20,conLevel["flowerMC"]);
         }
      }
      
      override public function destroy() : void
      {
         var mode:ActorModel = MainManager.actorModel;
         mode.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         this.clickMC.removeEventListener(MouseEvent.CLICK,this.showTip);
         UserManager.removeActionListener(MainManager.actorID,this.onAction);
         this.balkMC = null;
         this.catchTimer.stop();
         this.catchTimer.removeEventListener(TimerEvent.TIMER,this.onCatchTimer);
         this.catchTimer = null;
      }
      
      private function onAction(e:PeopleActionEvent) : void
      {
         var clothes:Array = null;
         var array:Array = null;
         var i:PeopleItemInfo = null;
         switch(e.actionType)
         {
            case PeopleActionEvent.CLOTH_CHANGE:
               clothes = e.data as Array;
               array = [];
               for each(i in clothes)
               {
                  array.push(i.id);
               }
               if(array.indexOf(100011) != -1)
               {
                  DisplayUtil.removeForParent(this.balkMC);
                  DisplayUtil.removeForParent(this.clickMC);
                  MapManager.currentMap.makeMapArray();
               }
               else
               {
                  typeLevel.addChild(this.balkMC);
                  conLevel.addChild(this.clickMC);
                  if(this.clickMC.hitTestPoint(MainManager.actorModel.pos.x,MainManager.actorModel.pos.y,true))
                  {
                     MainManager.actorModel.walkAction(new Point(608,245));
                  }
                  MapManager.currentMap.makeMapArray();
               }
         }
      }
      
      private function showTip(event:MouseEvent) : void
      {
         Alarm.show("你必须穿上" + TextFormatUtil.getRedTxt("履带") + "才能进入沼泽哦！\n" + "(你可以在" + TextFormatUtil.getRedTxt("机械室") + "的" + TextFormatUtil.getRedTxt("赛尔工厂") + "中购买到)");
      }
      
      public function clearWaste() : void
      {
         NewInstructorContoller.setWaste();
      }
      
      public function hitFlower() : void
      {
         var str:String = null;
         var id_str:uint = 0;
         if(this.isCacthing || this.isFlower)
         {
            return;
         }
         if(TasksManager.getTaskStatus(403) == TasksManager.UN_ACCEPT)
         {
            str = "你还没有领取" + TextFormatUtil.getRedTxt("小医生布布") + "任务呢，" + "快点击右上角的" + TextFormatUtil.getRedTxt("精灵训练营") + "按钮看看吧！";
            Alarm.show(str);
            return;
         }
         var mode:ActorModel = MainManager.actorModel;
         var petMode:PetModel = mode.pet;
         if(Boolean(petMode))
         {
            id_str = uint(petMode.info.petID);
            if(this.check(id_str))
            {
               mode.addEventListener(RobotEvent.WALK_START,this.onWalkStart);
               this.catchTimer.stop();
               this.catchTimer.reset();
               this.catchTimer.start();
               this.isCacthing = true;
               if(id_str == 1 || id_str == 301)
               {
                  conLevel["effectMC"].gotoAndStop("one");
                  topLevel["movie"].gotoAndStop("one");
               }
               else if(id_str == 2 || id_str == 302)
               {
                  conLevel["effectMC"].gotoAndStop("two");
                  topLevel["movie"].gotoAndStop("two");
               }
               else if(id_str == 3 || id_str == 303)
               {
                  conLevel["effectMC"].gotoAndStop("three");
                  topLevel["movie"].gotoAndStop("three");
               }
               TweenLite.to(topLevel["movie"],1,{
                  "x":(MainManager.getStageWidth() - topLevel["movie"].width) / 2,
                  "onComplete":this.onComp
               });
               PetManager.showCurrent();
            }
            else
            {
               Alarm.show("你必须带上<font color=\'#ff0000\'>布布种子、布布草、布布花、黄金布布、蒙娜布布、丽莎布布</font>的其中一个才能给克洛斯花补充活力哦！");
               conLevel["effectMC"].gotoAndStop(1);
            }
         }
         else
         {
            Alarm.show("你必须带上<font color=\'#ff0000\'>布布种子、布布草、布布花、黄金布布、蒙娜布布、丽莎布布</font>的其中一个才能给克洛斯花补充活力哦！");
            conLevel["effectMC"].gotoAndStop(1);
         }
      }
      
      private function check(id:uint) : Boolean
      {
         var a:Array = [1,2,3,301,302,303];
         var b:Boolean = false;
         for(var i1:int = 0; i1 < a.length; i1++)
         {
            if(a[i1] == id)
            {
               return true;
            }
         }
         return b;
      }
      
      private function onComp() : void
      {
         setTimeout(this.closeFlower,2000);
      }
      
      private function closeFlower() : void
      {
         try
         {
            topLevel["movie"].x = 1075;
         }
         catch(e:Error)
         {
         }
      }
      
      private function onCatchTimer(event:TimerEvent) : void
      {
         this.isCacthing = false;
         TasksManager.complete(403,0,this.onSuccess);
      }
      
      private function onSuccess(b:Boolean) : void
      {
         this.isFlower = b;
         if(this.isFlower)
         {
            conLevel["flowerMC"].gotoAndStop("live");
            conLevel["effectMC"].gotoAndStop(1);
            PetManager.showCurrent();
         }
         else
         {
            Alarm.show("这次补充活力似乎没有起到效果，再试试吧！");
         }
      }
      
      private function onWalkStart(event:RobotEvent) : void
      {
         if(this.isCacthing)
         {
            Alarm.show("随便走动是无法为克洛斯花补充能量的哦！");
            this.isCacthing = false;
            this.catchTimer.stop();
            conLevel["effectMC"].gotoAndStop(1);
            PetManager.showCurrent();
         }
      }
   }
}

