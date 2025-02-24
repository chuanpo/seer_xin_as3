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
   import flash.text.TextField;
   import gs.TweenLite;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class UpdateLevelPanel extends Sprite
   {
      private var levelPanel:MovieClip;
      
      private var iconMC:Sprite;
      
      private var btn:SimpleButton;
      
      private var isEvolution:Boolean;
      
      private var oldPetMC:MovieClip;
      
      private var evoPetMC:MovieClip;
      
      private var arrowArray:Array = [];
      
      private var txtArray:Array = [];
      
      private var txtArray2:Array = [];
      
      private var effectMC:MovieClip;
      
      public function UpdateLevelPanel()
      {
         super();
         this.levelPanel = UIManager.getMovieClip("ui_PetUpdateLevelPanel");
         this.iconMC = new Sprite();
         this.iconMC.x = 95 + 10;
         this.iconMC.y = 185 + 30;
         this.iconMC.scaleY = 1.5;
         this.iconMC.scaleX = 1.5;
         this.levelPanel.addChild(this.iconMC);
         this.btn = this.levelPanel["okBtn"];
         this.btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
         addChild(this.levelPanel);
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         this.clearArrow();
         this.txtArray = [];
         this.txtArray2 = [];
         this.arrowArray = [];
         DisplayUtil.removeForParent(this);
         DisplayUtil.removeForParent(this.effectMC);
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this,true);
         this.btn.removeEventListener(MouseEvent.CLICK,this.clickHandler);
         this.levelPanel = null;
         this.iconMC = null;
         this.btn = null;
         this.oldPetMC = null;
         this.evoPetMC = null;
         this.effectMC = null;
      }
      
      public function setInfo(updateInfo:UpdatePropInfo, petInfo:PetInfo) : void
      {
         this.clearArrow();
         this.txtArray.push(this.levelPanel["level_txt"],this.levelPanel["hp_txt"],this.levelPanel["a_txt"],this.levelPanel["d_txt"],this.levelPanel["sa_txt"],this.levelPanel["sd_txt"],this.levelPanel["sp_txt"]);
         this.txtArray2.push(this.levelPanel["level_txt2"],this.levelPanel["hp_txt2"],this.levelPanel["a_txt2"],this.levelPanel["d_txt2"],this.levelPanel["sa_txt2"],this.levelPanel["sd_txt2"],this.levelPanel["sp_txt2"]);
         this.levelPanel["name_txt"].text = PetXMLInfo.getName(petInfo.id);
         this.levelPanel["exp_info_txt"].htmlText = "赛尔精灵获得经验：<font color=\'#ff0000\'>" + (updateInfo.exp - petInfo.exp) + "\r</font>成功升级到了<font color=\'#ff0000\'>" + updateInfo.level + "</font>级";
         var oldProp:Array = [petInfo.level,petInfo.maxHp,petInfo.attack,petInfo.defence,petInfo.s_a,petInfo.s_d,petInfo.speed];
         var newProp:Array = [updateInfo.level,updateInfo.maxHp,updateInfo.attack,updateInfo.defence,updateInfo.sa,updateInfo.sd,updateInfo.sp];
         this.isEvolution = petInfo.id < updateInfo.id;
         this.showInfo(oldProp,newProp);
         if(this.isEvolution)
         {
            ResourceManager.getResource(ClientConfig.getPetSwfPath(petInfo.id),this.onLoadOld,"pet");
         }
         ResourceManager.getResource(ClientConfig.getPetSwfPath(updateInfo.id),this.onLevelComplete,"pet");
      }
      
      private function showInfo(oldProp:Array, newProp:Array) : void
      {
         var i:uint = 0;
         var txt:TextField = null;
         var txt2:TextField = null;
         var change:int = 0;
         var mc:MovieClip = null;
         var count:uint = 0;
         for each(i in oldProp)
         {
            txt = this.txtArray[count];
            txt2 = this.txtArray2[count];
            change = newProp[count] - oldProp[count];
            txt.text = "+" + change;
            txt2.text = newProp[count];
            if(change > 0)
            {
               txt.textColor = 16711680;
               mc = UIManager.getMovieClip("UpdateArrow");
               mc.x = txt.x + txt.width;
               mc.y = txt.y;
               this.levelPanel.addChild(mc);
               this.arrowArray.push(mc);
            }
            count++;
         }
      }
      
      private function clearArrow() : void
      {
         var i:MovieClip = null;
         var txt:TextField = null;
         if(Boolean(this.iconMC))
         {
            DisplayUtil.removeAllChild(this.iconMC);
         }
         for each(i in this.arrowArray)
         {
            DisplayUtil.removeForParent(i);
         }
         this.arrowArray = [];
         for each(txt in this.txtArray)
         {
            txt.textColor = 26112;
         }
      }
      
      private function onLoadOld(o:DisplayObject) : void
      {
         this.oldPetMC = o as MovieClip;
         if(Boolean(this.oldPetMC))
         {
            this.oldPetMC.gotoAndStop("rightdown");
            this.oldPetMC.addEventListener(Event.ENTER_FRAME,function():void
            {
               var mc:MovieClip = oldPetMC.getChildAt(0) as MovieClip;
               if(Boolean(mc))
               {
                  mc.gotoAndStop(1);
                  oldPetMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            this.oldPetMC.scaleX = 1.5;
            this.oldPetMC.scaleY = 1.5;
            if(this.isEvolution)
            {
               this.iconMC.addChild(this.oldPetMC);
            }
         }
      }
      
      private function onLevelComplete(o:DisplayObject) : void
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
            if(this.isEvolution)
            {
               this.evoPetMC.alpha = 0;
               this.showEvolution();
            }
         }
      }
      
      private function showEvolution() : void
      {
         TweenLite.to(this.oldPetMC,1,{
            "alpha":0,
            "onComplete":this.onComp
         });
         this.effectMC = UIManager.getMovieClip("ui_PetEvolution_MC");
         this.effectMC.x = 61;
         this.effectMC.y = 190;
         this.levelPanel.addChild(this.effectMC);
      }
      
      private function onComp() : void
      {
         TweenLite.to(this.evoPetMC,1,{"alpha":1});
      }
   }
}

