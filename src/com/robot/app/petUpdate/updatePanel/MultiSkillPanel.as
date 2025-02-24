package com.robot.app.petUpdate.updatePanel
{
   import com.robot.app.petUpdate.panel.SkillBtnController;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.PetSkillInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.skillBtn.BlackSkillBtn;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MultiSkillPanel extends Sprite
   {
      private var panel:MovieClip;
      
      private var replaceBtn:SimpleButton;
      
      private var closeBtn:SimpleButton;
      
      private var skillBtns:Array;
      
      private var study:uint;
      
      private var drop:uint = 0;
      
      private var newSkillMC:BlackSkillBtn;
      
      private var _catchTime:uint;
      
      private var iconMC:Sprite;
      
      public function MultiSkillPanel()
      {
         super();
         this.panel = UIManager.getMovieClip("ui_PetUpdateMoreSkillPanel");
         addChild(this.panel);
         this.replaceBtn = this.panel["okBtn"];
         this.closeBtn = this.panel["closeBtn"];
         this.replaceBtn.addEventListener(MouseEvent.CLICK,this.replaceHandler);
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         SocketConnection.addCmdListener(CommandID.PET_STUDY_SKILL,this.onStudy);
         this.iconMC = new Sprite();
         this.iconMC.x = 104;
         this.iconMC.y = 150;
         this.panel.addChild(this.iconMC);
      }
      
      public function setInfo(catchTime:uint, skillID:uint, isBag:Boolean = true) : void
      {
         var petSkills:Array = null;
         var petID:uint = 0;
         DisplayUtil.removeAllChild(this.iconMC);
         this._catchTime = catchTime;
         this.replaceBtn.mouseEnabled = false;
         this.replaceBtn.filters = [ColorFilter.setGrayscale()];
         DisplayUtil.removeForParent(this.newSkillMC);
         this.newSkillMC = new BlackSkillBtn(skillID);
         this.newSkillMC.x = 176;
         this.newSkillMC.y = 99;
         this.panel.addChild(this.newSkillMC);
         this.study = skillID;
         this.skillBtns = [];
         SocketConnection.addCmdListener(CommandID.GET_PET_INFO,function(e:SocketEvent):void
         {
            var i:PetSkillInfo = null;
            var mc:BlackSkillBtn = null;
            var con:SkillBtnController = null;
            SocketConnection.removeCmdListener(CommandID.GET_PET_INFO,arguments.callee);
            var info:PetInfo = e.data as PetInfo;
            petSkills = info.skillArray;
            var count:uint = 0;
            for each(i in petSkills)
            {
               mc = new BlackSkillBtn(i.id,i.pp);
               con = new SkillBtnController(mc,i);
               mc.x = 39 + count % 2 * (mc.width + 8);
               mc.y = 190 + Math.floor(count / 2) * (mc.height + 3);
               con.addEventListener(SkillBtnController.CLICK,onClickSkillBtn);
               skillBtns.push(con);
               panel.addChild(mc);
               count++;
            }
            ResourceManager.getResource(ClientConfig.getPetSwfPath(petID),onShowComplete,"pet");
         });
         SocketConnection.send(CommandID.GET_PET_INFO,this._catchTime);
      }
      
      private function onClickSkillBtn(event:Event) : void
      {
         var i:SkillBtnController = null;
         var con:SkillBtnController = event.currentTarget as SkillBtnController;
         this.drop = con.skillID;
         for each(i in this.skillBtns)
         {
            i.checkIsOwner(con);
         }
         this.replaceBtn.mouseEnabled = true;
         this.replaceBtn.filters = [];
      }
      
      private function replaceHandler(event:MouseEvent) : void
      {
         var okBtn:SimpleButton;
         var closeBtn:SimpleButton;
         var alarm:MovieClip = null;
         alarm = UIManager.getMovieClip("ui_MultiSkillAlarm");
         var newMC:BlackSkillBtn = new BlackSkillBtn(this.study);
         var oldMC:BlackSkillBtn = new BlackSkillBtn(this.drop);
         newMC.x = 39;
         oldMC.x = 195;
         oldMC.y = 102;
         newMC.y = 102;
         alarm.addChild(newMC);
         alarm.addChild(oldMC);
         DisplayUtil.align(alarm,null,AlignType.MIDDLE_CENTER);
         okBtn = alarm["okBtn"];
         closeBtn = alarm["closeBtn"];
         okBtn.addEventListener(MouseEvent.CLICK,function():void
         {
            DisplayUtil.removeForParent(alarm);
            SocketConnection.send(CommandID.PET_STUDY_SKILL,_catchTime,1,1,drop,study);
            trace("study new skill：" + study + "，drop skill：" + drop);
         });
         closeBtn.addEventListener(MouseEvent.CLICK,function():void
         {
            DisplayUtil.removeForParent(alarm);
         });
         MainManager.getStage().addChild(alarm);
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      private function onStudy(event:SocketEvent) : void
      {
         var sprite:Sprite;
         PetManager.upDate();
         sprite = Alarm.show("恭喜你，宠物学习技能成功！",function():void
         {
            dispatchEvent(new Event(Event.CLOSE));
         });
         MainManager.getStage().addChild(sprite);
      }
      
      private function onShowComplete(o:DisplayObject) : void
      {
         var _showMc:MovieClip = null;
         _showMc = o as MovieClip;
         if(Boolean(_showMc))
         {
            _showMc.gotoAndStop("rightdown");
            _showMc.addEventListener(Event.ENTER_FRAME,function():void
            {
               var mc:MovieClip = _showMc.getChildAt(0) as MovieClip;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(1);
                  _showMc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            this.iconMC.addChild(_showMc);
         }
      }
   }
}

