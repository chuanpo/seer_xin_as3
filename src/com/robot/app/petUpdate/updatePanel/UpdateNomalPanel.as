package com.robot.app.petUpdate.updatePanel
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class UpdateNomalPanel extends Sprite
   {
      protected var panel:MovieClip;
      
      protected var btn:SimpleButton;
      
      protected var evoPetMC:MovieClip;
      
      protected var iconMC:Sprite;
      
      public function UpdateNomalPanel()
      {
         super();
         this.initUI();
      }
      
      protected function initUI() : void
      {
         this.panel = UIManager.getMovieClip("ui_PetUpdateNormalPanel");
         this.iconMC = new Sprite();
         this.iconMC.x = 170;
         this.iconMC.y = 120;
         this.iconMC.scaleY = 0.9;
         this.iconMC.scaleX = 0.9;
         this.panel.addChild(this.iconMC);
         addChild(this.panel);
         this.btn = this.panel["okBtn"];
         this.btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      protected function clickHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         DisplayUtil.removeAllChild(this.iconMC);
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this,true);
         this.panel = null;
         this.btn = null;
         this.iconMC = null;
      }
      
      public function setInfo(updateInfo:UpdatePropInfo, petInfo:PetInfo) : void
      {
         this.panel["name_txt"].text = PetXMLInfo.getName(petInfo.id);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(updateInfo.id),this.onLevelComplete,"pet");
         this.panel["exp_info_txt"].htmlText = "赛尔精灵获得经验：<font color=\'#ff0000\'>" + (updateInfo.exp - petInfo.exp) + "</font>\r" + "离升级还需经验：<font color=\'#ff0000\'>" + (updateInfo.nextLvExp - updateInfo.exp) + "</font>";
      }
      
      protected function onLevelComplete(o:DisplayObject) : void
      {
         this.evoPetMC = o as MovieClip;
         if(Boolean(this.evoPetMC))
         {
            this.evoPetMC.gotoAndStop("rightdown");
            this.evoPetMC.addEventListener(Event.ENTER_FRAME,function():void
            {
               var mc:MovieClip = evoPetMC.getChildAt(0) as MovieClip;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(1);
                  evoPetMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            this.evoPetMC.scaleX = 1.5;
            this.evoPetMC.scaleY = 1.5;
            this.iconMC.addChild(this.evoPetMC);
         }
      }
   }
}

