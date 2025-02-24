package com.robot.app.aimat.state
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import org.taomee.utils.DisplayUtil;
   
   public class AimatState_0 implements IAimatState
   {
      private var _ui:MovieClip;
      
      private var _count:int = 0;
      
      public function AimatState_0()
      {
         super();
      }
      
      public function get isFinish() : Boolean
      {
         ++this._count;
         if(this._count >= 50)
         {
            return true;
         }
         return false;
      }
      
      public function execute(obj:IAimatSprite, info:AimatInfo) : void
      {
         var rect:Rectangle = null;
         rect = obj.hitRect;
         this._ui = AimatController.getResState(info.id);
         this._ui.mouseEnabled = false;
         this._ui.mouseChildren = false;
         this._ui.x = rect.width / 2 - Math.random() * rect.width + obj.centerPoint.x - obj.sprite.x;
         this._ui.y = -Math.random() * rect.height + obj.centerPoint.y - obj.sprite.y;
         obj.sprite.addChild(this._ui);
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this._ui);
         this._ui = null;
      }
   }
}

