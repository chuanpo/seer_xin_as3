package com.robot.app.aimat.state
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimatState;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.mode.IAimatSprite;
   import flash.display.MovieClip;
   import flash.filters.ColorMatrixFilter;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.MovieClipUtil;
   
   public class AimatState_2 implements IAimatState
   {
      private var _maoyan:MovieClip;
      
      private var _obj:IAimatSprite;
      
      private var _count:int = 0;
      
      public function AimatState_2()
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
         var objmc:MovieClip = null;
         this._obj = obj;
         var matrix:Array = [0.6,1.2,0.1,0,-263,0.6,1.2,0.16,0,-263,0.6,1.2,0.16,0,-263,0,0,0,1,0];
         if(obj.sprite is BasePeoleModel)
         {
            objmc = BasePeoleModel(obj.sprite).skeleton.getSkeletonMC();
            objmc.filters = [new ColorMatrixFilter(matrix)];
            this._maoyan = AimatController.getResState(10001);
            this._maoyan.mouseEnabled = false;
            this._maoyan.y = -obj.hitRect.height;
            obj.sprite.addChildAt(this._maoyan,0);
         }
         else
         {
            obj.sprite.filters = [new ColorMatrixFilter(matrix)];
         }
      }
      
      public function destroy() : void
      {
         var diaozha:MovieClip = null;
         if(this._obj is BasePeoleModel)
         {
            if(Boolean(this._maoyan))
            {
               DisplayUtil.removeForParent(this._maoyan);
               this._maoyan = null;
            }
            BasePeoleModel(this._obj).skeleton.getSkeletonMC().filters = [];
            diaozha = AimatController.getResState(1000102);
            diaozha.x = this._obj.sprite.x;
            diaozha.y = this._obj.sprite.y;
            MovieClipUtil.playEndAndRemove(diaozha);
            MapManager.currentMap.depthLevel.addChild(diaozha);
         }
         else
         {
            this._obj.sprite.filters = [];
         }
         this._obj = null;
      }
   }
}

