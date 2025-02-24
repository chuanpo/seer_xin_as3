package com.robot.app.mapProcess
{
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   
   public class MapProcess_16 extends BaseMapProcess
   {
      private var gasMC:MovieClip;
      
      private var type:uint;
      
      public function MapProcess_16()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.gasMC = conLevel["gasEffectMC"];
         this.gasMC.gotoAndStop(3);
      }
      
      override public function destroy() : void
      {
         this.gasMC = null;
      }
      
      public function exploitGas() : void
      {
         EnergyController.exploit();
      }
   }
}

