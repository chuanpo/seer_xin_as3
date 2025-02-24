package com.robot.app.petUpdate.panel
{
   import com.robot.core.info.pet.PetSkillInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class SkillBtnController extends EventDispatcher
   {
      public static const CLICK:String = "click";
      
      private var mc:Sprite;
      
      private var _skillID:uint;
      
      private var redFilter:GlowFilter = new GlowFilter(16711680,0.8,5,5,2);
      
      public function SkillBtnController(mc:Sprite, info:PetSkillInfo)
      {
         super();
         this.mc = mc;
         this._skillID = info.id;
         mc.addEventListener(MouseEvent.CLICK,this.clickHandler);
      }
      
      public function get skillID() : uint
      {
         return this._skillID;
      }
      
      public function checkIsOwner(con:SkillBtnController) : void
      {
         if(con == this)
         {
            this.mc.filters = [this.redFilter];
         }
         else
         {
            this.mc.filters = [];
         }
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         dispatchEvent(new Event(CLICK));
      }
   }
}

