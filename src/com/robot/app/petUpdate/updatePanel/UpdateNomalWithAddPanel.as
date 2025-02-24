package com.robot.app.petUpdate.updatePanel
{
   import com.robot.app.petUpdate.PetUpdatePropController;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.UIManager;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.manager.ResourceManager;
   
   public class UpdateNomalWithAddPanel extends UpdateNomalPanel
   {
      public function UpdateNomalWithAddPanel()
      {
         super();
      }
      
      override protected function initUI() : void
      {
         panel = UIManager.getMovieClip("ui_PetUpdateNormalWithAddPanel");
         iconMC = new Sprite();
         iconMC.x = 188;
         iconMC.y = 170;
         iconMC.scaleY = 0.9;
         iconMC.scaleX = 0.9;
         panel.addChild(iconMC);
         addChild(panel);
         btn = panel["okBtn"];
         btn.addEventListener(MouseEvent.CLICK,clickHandler);
      }
      
      override public function setInfo(updateInfo:UpdatePropInfo, petInfo:PetInfo) : void
      {
         if(PetUpdatePropController.addPer == 10)
         {
            panel["txt"].text = "赛尔精灵获得经验：\rNoNo加成经验：\r离升级还需经验：\r";
            panel["nonoMC"].gotoAndStop(2);
         }
         else
         {
            panel["txt"].text = "赛尔精灵获得经验：\r超能NoNo加成经验：\r离升级还需经验：\r";
            panel["nonoMC"].gotoAndStop(1);
         }
         var ad:Number = PetUpdatePropController.addition;
         var old:uint = Math.floor((updateInfo.exp - petInfo.exp) / (1 + ad));
         panel["add_txt"].text = "EXP+" + PetUpdatePropController.addPer + "%";
         panel["seer_exp_txt"].text = old.toString();
         panel["nono_exp_txt"].text = updateInfo.exp - petInfo.exp - old;
         panel["up_exp_txt"].text = updateInfo.nextLvExp - updateInfo.exp;
         panel["total_exp_txt"].text = updateInfo.exp - petInfo.exp;
         panel["name_txt"].text = PetXMLInfo.getName(petInfo.id);
         ResourceManager.getResource(ClientConfig.getPetSwfPath(updateInfo.id),onLevelComplete,"pet");
      }
   }
}

