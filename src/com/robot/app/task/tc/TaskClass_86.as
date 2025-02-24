package com.robot.app.task.tc
{
   import com.robot.app.task.newNovice.NewNoviceStepThreeController;
   import com.robot.app.task.newNovice.NewNoviceStepTwoController;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.PetInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.events.Event;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskClass_86
   {
      private var mc:MovieClip;
      
      private var _info:NoviceFinishInfo;
      
      public function TaskClass_86(info:NoviceFinishInfo)
      {
         super();
         this._info = info;
         TasksManager.setTaskStatus(86,TasksManager.COMPLETE);
         PetManager.setIn(info.captureTm,1);
         this.mc = MapManager.currentMap.controlLevel["mc" + info.petID];
         this.mc.gotoAndPlay(2);
         this.mc.addEventListener(Event.ENTER_FRAME,this.onEnHandler);
      }
      
      private function onEnHandler(e:Event) : void
      {
         if(this.mc.currentFrame == this.mc.totalFrames)
         {
            this.mc.removeEventListener(Event.ENTER_FRAME,this.onEnHandler);
            DisplayUtil.removeForParent(this.mc);
            this.mc = null;
            PetInBagAlert.show(this._info.petID,"一只" + TextFormatUtil.getRedTxt(PetXMLInfo.getName(this._info.petID)) + "已经放入你的精灵背包,要好好照顾它哦！",LevelManager.appLevel,this.onHandler);
         }
      }
      
      private function onHandler() : void
      {
         this._info = null;
         NewNoviceStepTwoController.destroy();
         NewNoviceStepThreeController.start();
      }
   }
}

