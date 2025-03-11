package com.robot.app.mapProcess
{
   import com.robot.app.ogre.OgreController;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.effect.LightEffect;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.PetModel;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.npc.NPC;
   import com.robot.app.energy.utils.EnergyController;
   
   public class MapProcess_328 extends BaseMapProcess
   {
      private var count:uint = 0;
      
      private var _door_0:MovieClip;

      // private var _animator_mc:MovieClip;

      public function MapProcess_328()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._door_0 = conLevel["door_0"];
         this._door_0.visible = false;
      }
      
      override public function destroy() : void
      {
      }
      public function exploitGas() : void
      {
         // NpcDialog.show(NPC.SEER,["暂时不可开采哟~"],["可恶...."],[function():void{}])
         EnergyController.exploit();
      }
   }
}

