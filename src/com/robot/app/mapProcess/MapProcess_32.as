package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.SeerInstructor.NewInstructorContoller;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_32 extends BaseMapProcess
   {
      private var _rockMc:MovieClip;
      
      private var _rockBtn:MovieClip;
      
      public function MapProcess_32()
      {
         super();
      }
      
      override protected function init() : void
      {
         NewInstructorContoller.chekWaste();
         this._rockMc = conLevel.getChildByName("rockMc") as MovieClip;
         this._rockMc.gotoAndStop(1);
         this._rockMc.buttonMode = true;
         this._rockMc.mouseEnabled = false;
         this._rockMc.visible = false;
         this._rockBtn = conLevel.getChildByName("rockBtn") as MovieClip;
         this._rockBtn.mouseEnabled = false;
         this._rockBtn.visible = false;
         this._rockBtn.buttonMode = true;
         EventManager.addEventListener("LY_OUT",this.onLYShow);
         conLevel["bossBtn"].mouseEnabled = false;
         this.check();
      }
      
      private function onLYShow(event:Event) : void
      {
         this.showLY();
      }
      
      private function showLY() : void
      {
         conLevel["bossMc"]["mc"].gotoAndPlay(2);
         conLevel["bossBtn"].mouseEnabled = true;
      }
      
      public function hitLY() : void
      {
         FightInviteManager.fightWithBoss("雷伊");
      }
      
      private function check() : void
      {
         if(TasksManager.getTaskStatus(401) == TasksManager.ALR_ACCEPT)
         {
            TasksManager.getProStatus(401,1,function(b:Boolean):void
            {
               if(!b)
               {
                  _rockMc.mouseEnabled = true;
                  _rockMc.visible = true;
                  _rockBtn.mouseEnabled = true;
                  _rockBtn.visible = true;
               }
            });
         }
      }
      
      override public function destroy() : void
      {
         EventManager.removeEventListener("LY_OUT",this.onLYShow);
         this._rockMc.removeEventListener(MouseEvent.CLICK,this.onMusicClick);
         this._rockMc = null;
         this._rockBtn = null;
      }
      
      private function onMusicClick(e:MouseEvent) : void
      {
         if(!MainManager.actorModel.getIsPetFollw(22) && !MainManager.actorModel.getIsPetFollw(23) && !MainManager.actorModel.getIsPetFollw(24))
         {
            Alarm.show("只有带上你的<font color=\'#ff0000\'>毛毛</font>，这些音符才会起到作用呢。");
            return;
         }
         TasksManager.complete(401,1,function(b:Boolean):void
         {
            _rockMc.removeEventListener(MouseEvent.CLICK,onMusicClick);
            if(b)
            {
               DisplayUtil.removeForParent(_rockMc);
               Alarm.show("你帮助毛毛找到了一个音符！");
            }
         });
      }
      
      public function clearWaste() : void
      {
         NewInstructorContoller.setWaste();
      }
      
      public function onRockHit() : void
      {
         DisplayUtil.removeForParent(this._rockBtn);
         this._rockMc.gotoAndStop(2);
         this._rockMc.addEventListener(MouseEvent.CLICK,this.onMusicClick);
      }
      
      public function onbossHit() : void
      {
         FightInviteManager.fightWithBoss("雷伊");
      }
   }
}

