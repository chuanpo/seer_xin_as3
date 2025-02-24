package com.robot.core.mode
{
   import com.robot.core.event.NpcEvent;
   import com.robot.core.info.NpcTaskInfo;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NpcTaskManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcInfo;
   import com.robot.core.ui.DialogBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import org.taomee.manager.DepthManager;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   
   [Event(name="taskWithoutDes",type="com.robot.core.event.NpcEvent")]
   [Event(name="npcClick",type="com.robot.core.event.NpcEvent")]
   public class NpcModel extends BasePeoleModel
   {
      private var _taskInfo:NpcTaskInfo;
      
      private var _npc:Sprite;
      
      private var clickPoint:Point;
      
      private var _npcHit:Sprite;
      
      private var questionMark:MovieClip;
      
      private var excalMark:MovieClip;
      
      private var _type:String;
      
      private var _id:uint;
      
      private var dialogList:Array;
      
      public var des:String;
      
      private var timer:Timer;
      
      private var _npcInfo:NpcInfo;
      
      private var diaUint:uint = 0;
      
      private var posList:Array;
      
      private var npcTimer:Timer;
      
      public function NpcModel(info:NpcInfo, npc:Sprite)
      {
         var i:uint = 0;
         this.dialogList = [];
         this.posList = [new Point(280,291),new Point(420,340),new Point(611,427),new Point(200,500)];
         this._npcInfo = info;
         this._id = this._npcInfo.npcId;
         this._type = this._npcInfo.type;
         this._npc = npc;
         this._npcHit = this._npc;
         this.des = this._npcInfo.dialogList[0];
         this.dialogList = this._npcInfo.bubbingList;
         this.questionMark = new lib_question_mark();
         this.excalMark = new lib_excalmatory_mark();
         this.setNpcTaskIDs(this._npcInfo.startIDs,this._npcInfo.endIDs,this._npcInfo.proIDs);
         var userInfo:UserInfo = new UserInfo();
         userInfo.nick = this._npcInfo.npcName;
         userInfo.direction = 3;
         if(this._npcInfo.clothIds.length == 0)
         {
            MapManager.currentMap.depthLevel.addChild(this._npc);
            this._npc.x = this._npcInfo.point.x;
            this._npc.y = this._npcInfo.point.y;
            DepthManager.swapDepthAll(MapManager.currentMap.depthLevel);
         }
         else
         {
            for each(i in this._npcInfo.clothIds)
            {
               userInfo.clothes.push(new PeopleItemInfo(i));
            }
            userInfo.color = this._npcInfo.color;
         }
         this._npc.buttonMode = true;
         super(userInfo);
         this.initNpc();
         this._npc.addEventListener(MouseEvent.CLICK,this.clickNpc);
         this.initDialog();
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      private function initDialog() : void
      {
         var box:DialogBox = null;
         this.timer = new Timer(9000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         if(this.dialogList.length > 0)
         {
            this.timer.start();
            if(this.diaUint == this.dialogList.length - 1)
            {
               this.diaUint = 0;
            }
            else
            {
               ++this.diaUint;
            }
            if(this.dialogList[this.diaUint] == "")
            {
               return;
            }
            box = new DialogBox();
            box.show(this.dialogList[this.diaUint],0,-100,this._npc);
         }
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         if(this.diaUint == this.dialogList.length - 1)
         {
            this.diaUint = 0;
         }
         else
         {
            ++this.diaUint;
         }
         if(this.dialogList[this.diaUint] == "")
         {
            return;
         }
         var box:DialogBox = new DialogBox();
         box.show(this.dialogList[this.diaUint],0,-100,this._npc);
      }
      
      public function refreshTask() : void
      {
         DisplayUtil.removeForParent(this.questionMark,false);
         DisplayUtil.removeForParent(this.excalMark,false);
         if(Boolean(this._taskInfo))
         {
            this._taskInfo.refresh();
         }
      }
      
      public function get id() : uint
      {
         return this._id;
      }
      
      override public function get name() : String
      {
         return this._npcInfo.npcName;
      }
      
      private function clickNpc(event:MouseEvent) : void
      {
         this.clickPoint = this._npcHit.localToGlobal(new Point(this._npcInfo.offSetPoint.x,this._npcInfo.offSetPoint.y));
         MainManager.actorModel.walkAction(this.clickPoint);
         this._npcHit.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(event:Event) : void
      {
         var pp:Point = MainManager.actorModel.sprite.localToGlobal(new Point());
         if(Point.distance(pp,this.clickPoint) < 15)
         {
            MainManager.actorModel.skeleton.stop();
            this._npcHit.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
            if(TasksManager.getTaskStatus(25) == TasksManager.ALR_ACCEPT && this._id == 1)
            {
               NpcTaskManager.dispatchEvent(new Event("50001"));
            }
            if(this._taskInfo.completeList.length > 0)
            {
               trace(">>>>>> some task can be completed");
               EventManager.dispatchEvent(new NpcEvent(NpcEvent.COMPLETE_TASK,this));
            }
            else
            {
               trace(">>>>>> show npc task list");
               EventManager.dispatchEvent(new NpcEvent(NpcEvent.SHOW_TASK_LIST,this));
            }
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         if(Boolean(this._taskInfo))
         {
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_BLUE_QUESTION,this.showBlueQuestion);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_EXCAL,this.showYellowExcal);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_QUESTION,this.showYellowQuestion);
            this._taskInfo.destroy();
         }
         this._taskInfo = null;
         this._npcHit.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         this._npc = null;
         this._npcHit = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         if(Boolean(this.npcTimer))
         {
            this.npcTimer.stop();
            this.npcTimer.removeEventListener(TimerEvent.TIMER,this.onNpcTimer);
         }
         this.npcTimer = null;
         this._taskInfo = null;
      }
      
      private function showBlueQuestion(event:Event) : void
      {
         var h:Number = this.npc.height;
         if(h > 110)
         {
            h = 120;
         }
         this.questionMark.y = -h;
         this.npc.addChild(this.questionMark);
         this.questionMark.gotoAndStop(1);
      }
      
      private function showYellowExcal(event:Event) : void
      {
         if(this._taskInfo.isRelateTask)
         {
            return;
         }
         var h:Number = this.npc.height;
         if(h > 110)
         {
            h = 120;
         }
         this.excalMark.y = -h;
         this.npc.addChild(this.excalMark);
      }
      
      private function showYellowQuestion(event:Event) : void
      {
         var h:Number = this.npc.height;
         if(h > 110)
         {
            h = 120;
         }
         this.questionMark.y = -h;
         this.npc.addChild(this.questionMark);
         this.questionMark.gotoAndStop(2);
      }
      
      public function get npc() : Sprite
      {
         return this._npc;
      }
      
      public function hide() : void
      {
         if(Boolean(this._npc))
         {
            this._npc.visible = false;
         }
      }
      
      public function show() : void
      {
         if(Boolean(this._npc))
         {
            this._npc.visible = true;
         }
      }
      
      public function setNpcTaskIDs(bindIDs:Array, completeIDs:Array, proIDs:Array) : void
      {
         if(Boolean(this._taskInfo))
         {
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_BLUE_QUESTION,this.showBlueQuestion);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_EXCAL,this.showYellowExcal);
            this._taskInfo.removeEventListener(NpcTaskInfo.SHOW_YELLOW_QUESTION,this.showYellowQuestion);
            this._taskInfo.destroy();
         }
         DisplayUtil.removeForParent(this.questionMark,false);
         DisplayUtil.removeForParent(this.excalMark,false);
         this._taskInfo = new NpcTaskInfo(bindIDs,completeIDs,proIDs,this);
         this._taskInfo.addEventListener(NpcTaskInfo.SHOW_BLUE_QUESTION,this.showBlueQuestion);
         this._taskInfo.addEventListener(NpcTaskInfo.SHOW_YELLOW_EXCAL,this.showYellowExcal);
         this._taskInfo.addEventListener(NpcTaskInfo.SHOW_YELLOW_QUESTION,this.showYellowQuestion);
         this._taskInfo.checkTaskStatus();
      }
      
      public function get taskInfo() : NpcTaskInfo
      {
         return this._taskInfo;
      }
      
      private function initNpc() : void
      {
         if(this.id != NPC.IRIS)
         {
            return;
         }
         clickBtn.mouseChildren = clickBtn.mouseEnabled = false;
         var shadow:MovieClip = new npc_shadow_mc();
         shadow.y += 15;
         addChildAt(shadow,0);
         this.mouseEnabled = true;
         this._npc = this;
         this._npcHit = this;
         this.buttonMode = true;
         _skeletonSys.getBodyMC().filters = [new GlowFilter(3355443,1,4,4)];
         _skeletonSys.getBodyMC().scaleX = _skeletonSys.getBodyMC().scaleY = 1.4;
         DisplayUtil.removeForParent(_skeletonSys.getSkeletonMC()["clickBtn"]);
         var txt:TextField = _nameTxt;
         txt.y += 15;
         var tf:TextFormat = new TextFormat();
         tf.size = 14;
         tf.color = 26367;
         txt.setTextFormat(tf);
         txt.filters = [new GlowFilter(16777215,1,3,3,5)];
         this.pos = new Point(704,405);
         this.npcTimer = new Timer(3000,0);
         this.npcTimer.addEventListener(TimerEvent.TIMER,this.onNpcTimer);
         this.npcTimer.start();
         MapManager.currentMap.depthLevel.addChild(this);
         this.pos = this._npcInfo.point;
      }
      
      private function onNpcTimer(event:TimerEvent) : void
      {
         var p:Point = this.posList[Math.floor(Math.random() * this.posList.length)];
         while(p.x == this.pos.x && p.y == this.pos.y)
         {
            p = this.posList[Math.floor(Math.random() * this.posList.length)];
         }
         _walk.execute_point(this,p,false);
      }
      
      override protected function onWalkEnd(e:Event) : void
      {
         trace("walk  end");
         _skeletonSys.stop();
         this.npcTimer.reset();
         this.npcTimer.start();
      }
      
      public function get npcInfo() : NpcInfo
      {
         return this._npcInfo;
      }
   }
}

