package com.robot.app.petUpdate.updatePanel
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.ui.skillBtn.BlackSkillBtn;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class SingleSkillPanel extends Sprite
   {
      private var panel:MovieClip;
      
      private var iconMC:Sprite;
      
      private var skillBtn:BlackSkillBtn;
      
      private var okBtn:SimpleButton;
      
      public function SingleSkillPanel()
      {
         super();
         this.panel = UIManager.getMovieClip("ui_PetUpdateSkillPanel");
         this.iconMC = new Sprite();
         this.iconMC.x = 108;
         this.iconMC.y = 135;
         this.iconMC.scaleY = 1.5;
         this.iconMC.scaleX = 1.5;
         this.panel.addChild(this.iconMC);
         this.okBtn = this.panel["okBtn"];
         this.okBtn.addEventListener(MouseEvent.CLICK,this.okHandler);
         addChild(this.panel);
      }
      
      public function setInfo(catchTime:uint, skillID:uint, isBag:Boolean = true) : void
      {
         var petID:uint = 0;
         DisplayUtil.removeAllChild(this.iconMC);
         if(isBag)
         {
            petID = uint(PetManager.getPetInfo(catchTime).id);
            this.panel["name_txt"].text = PetXMLInfo.getName(petID);
         }
         else
         {
            petID = uint(PetManager.curEndPetInfo.id);
            this.panel["name_txt"].text = PetXMLInfo.getName(petID);
         }
         ResourceManager.getResource(ClientConfig.getPetSwfPath(petID),this.onShowComplete,"pet");
         this.skillBtn = new BlackSkillBtn(skillID);
         this.skillBtn.x = 175;
         this.skillBtn.y = 100;
         this.panel.addChild(this.skillBtn);
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
      
      private function okHandler(event:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

