package com.robot.app.aimat.state
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import org.taomee.utils.DisplayUtil;
   
   public class AimatState_10005 implements IAimatState
   {
      private var _mc:MovieClip;
      
      private var _obj:DisplayObject;
      
      private var _count:int = 0;
      
      public function AimatState_10005()
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
         this._obj = BasePeoleModel(obj).skeleton.getSkeletonMC();
         var rect:Rectangle = obj.hitRect;
         this._mc = AimatController.getResState(info.id);
         this._mc.mouseEnabled = false;
         this._mc.mouseChildren = false;
         this._mc.x = obj.centerPoint.x - obj.sprite.x;
         this._mc.y = obj.centerPoint.y - obj.sprite.y;
         obj.sprite.addChild(this._mc);
         var ctf:ColorTransform = new ColorTransform();
         ctf.color = 16777215;
         if(obj is BasePeoleModel)
         {
            this._obj.transform.colorTransform = ctf;
         }
      }
      
      public function destroy() : void
      {
         this._obj.transform.colorTransform = new ColorTransform();
         DisplayUtil.removeForParent(this._mc);
         this._mc = null;
         this._obj = null;
      }
   }
}

