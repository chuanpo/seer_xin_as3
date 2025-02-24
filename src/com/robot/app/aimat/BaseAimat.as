package com.robot.app.aimat
{
   import com.robot.core.aimat.AimatController;
   import com.robot.core.aimat.IAimat;
   import com.robot.core.info.AimatInfo;
   
   public class BaseAimat implements IAimat
   {
      protected var _info:AimatInfo;
      
      public function BaseAimat()
      {
         super();
         AimatController.addAimat(this);
      }
      
      public function execute(info:AimatInfo) : void
      {
         this._info = info;
      }
      
      public function destroy() : void
      {
         AimatController.removeAimat(this);
         this._info = null;
      }
   }
}

