package com.robot.core.mode.spriteInteractive
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.UserEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.mode.BasePeoleModel;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ClothLightInteractive implements ISpriteInteractiveAction
   {
      private var model:BasePeoleModel;
      
      private var qqContainer:Sprite;
      
      public function ClothLightInteractive(model:BasePeoleModel)
      {
         super();
         this.model = model;
         this.qqContainer = new Sprite();
      }
      
      public function rollOver() : void
      {
         var max:uint = this.model.info.clothMaxLevel;
         if(max > 1)
         {
            ResourceManager.getResource(ClientConfig.getClothCircleUrl(max),this.onLoadQQ);
            if(this.model == MainManager.actorModel)
            {
               this.model.addChildAt(this.qqContainer,1);
            }
            else
            {
               this.model.addChildAt(this.qqContainer,0);
            }
         }
      }
      
      private function onLoadQQ(o:DisplayObject) : void
      {
         DisplayUtil.removeAllChild(this.qqContainer);
         this.qqContainer.addChild(o);
      }
      
      public function rollOut() : void
      {
         DisplayUtil.removeForParent(this.qqContainer);
      }
      
      public function click() : void
      {
         EventManager.dispatchEvent(new UserEvent(UserEvent.CLICK,this.model.info));
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.qqContainer);
         this.qqContainer = null;
      }
   }
}

