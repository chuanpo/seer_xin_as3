package com.robot.app.aimat.state
{
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.pet.PetShowInfo;
   import com.robot.core.mode.ActionSpriteModel;
   import com.robot.core.mode.IAimatSprite;
   import com.robot.core.mode.PetModel;
   
   public class AimatState_3 implements IAimatState
   {
      private var _mc:PetModel;
      
      private var _count:int = 0;
      
      private var objs:IAimatSprite;
      
      private var petArr:Array = [164,77,27,62,108];
      
      public function AimatState_3()
      {
         super();
      }
      
      public function get isFinish() : Boolean
      {
         if(Boolean(this.objs))
         {
            this._mc.x = this.objs.sprite.x;
            this._mc.y = this.objs.sprite.y;
            this._mc.direction = this.objs.direction;
         }
         ++this._count;
         if(this._count >= 50)
         {
            return true;
         }
         return false;
      }
      
      public function execute(obj:IAimatSprite, info:AimatInfo) : void
      {
         this.objs = obj;
         if(obj.sprite.visible == false)
         {
            return;
         }
         var actionModel:ActionSpriteModel = obj.sprite as ActionSpriteModel;
         this._mc = new PetModel(actionModel);
         var petinfo:PetShowInfo = new PetShowInfo();
         var n:int = int(Math.random() * 5);
         petinfo.petID = int(this.petArr[n]);
         this._mc.show(petinfo);
         this._mc.x -= 40;
         this._mc.y -= 5;
         obj.sprite.visible = false;
      }
      
      public function destroy() : void
      {
         this.objs.sprite.visible = true;
         this._mc.destroy();
         this._mc = null;
      }
   }
}

