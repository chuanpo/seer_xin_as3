package com.robot.app.petUpdate
{
   import com.robot.app.experienceShared.ExperienceSharedModel;
   import com.robot.app.petUpdate.updatePanel.UpdatePropManager;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.pet.update.PetUpdatePropInfo;
   import com.robot.core.info.pet.update.UpdatePropInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   
   public class PetUpdatePropController
   {
      public static var owner:PetUpdatePropController;
      
      public static var addPer:uint;
      
      public static var addition:Number;
      
      private var panel:MovieClip;
      
      private var expMC:MovieClip;
      
      private var expTxt:TextField;
      
      private var txtArray:Array = [];
      
      private var arrowArray:Array = [];
      
      private var iconMC:Sprite;
      
      private var infoArray:Array = [];
      
      private var btn:SimpleButton;
      
      private var bmp:Bitmap;
      
      public function PetUpdatePropController()
      {
         super();
         owner = this;
         EventManager.addEventListener(PetFightEvent.PET_UPDATE_PROP,this.onFightClose);
      }
      
      public function setup(data:PetUpdatePropInfo) : void
      {
         var info:UpdatePropInfo = null;
         var li:uint = 0;
         addition = data.addition;
         addPer = data.addPer;
         this.infoArray = data.dataArray.slice();
         for each(info in this.infoArray)
         {
            li = uint(PetXMLInfo.getEvolvingLv(info.id));
            if(PetXMLInfo.getTypeCN(info.id) == "机械")
            {
               if(info.level >= li && li != 0)
               {
                  Alarm.show("你的精灵已经达到了进化等级，现在可以在实验室的精灵进化仓里进行进化了。");
               }
            }
         }
         if(ExperienceSharedModel.isGetExp)
         {
            this.show();
         }
         ExperienceSharedModel.isGetExp = false;
      }
      
      private function onFightClose(event:PetFightEvent) : void
      {
         this.bmp = event.dataObj as Bitmap;
         if(this.infoArray.length == 0)
         {
            DisplayUtil.removeForParent(this.bmp);
            this.bmp = null;
            PetManager.upDate();
            return;
         }
         this.show();
      }
      
      public function show(showByLevelPanel:Boolean = false, isBag:Boolean = true) : void
      {
         var petInfo:PetInfo = null;
         var data:UpdatePropInfo = this.infoArray.shift() as UpdatePropInfo;
         if(isBag)
         {
            petInfo = PetManager.getPetInfo(data.catchTime);
         }
         else
         {
            petInfo = PetManager.curEndPetInfo;
         }
         UpdatePropManager.update(data,petInfo,this.closeHandler,showByLevelPanel);
      }
      
      private function closeHandler() : void
      {
         if(this.infoArray.length > 0)
         {
            this.show();
         }
         else
         {
            this.infoArray = [];
            if(PetUpdateSkillController.infoArray.length > 0)
            {
               EventManager.dispatchEvent(new PetFightEvent(PetFightEvent.PET_UPDATE_SKILL,this.bmp));
            }
            else
            {
               if(Boolean(this.bmp))
               {
               }
               DisplayUtil.removeForParent(this.bmp);
            }
            PetManager.upDate();
            this.bmp = null;
         }
      }
   }
}

