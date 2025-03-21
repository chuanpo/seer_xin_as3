package com.robot.app.mapProcess
{
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.BossModel;
   import flash.geom.Point;
   import flash.events.MouseEvent;
   import com.robot.app.fightNote.FightInviteManager;
   import org.taomee.manager.ToolTipManager;
   import com.robot.core.utils.Direction;

   public class MapProcess_48 extends BaseMapProcess
   {
      private var _bossMC:BossModel;

      public function MapProcess_48()
      {
         super();
      }
      override protected function init() : void
      {
         if(!this._bossMC)
         {
            this._bossMC = new BossModel(2535,48);
            this._bossMC.setDirection(Direction.RIGHT);
            this._bossMC.show(new Point(100,450),0);
            this._bossMC.scaleX = this._bossMC.scaleY = 2;
         }
         this._bossMC.mouseEnabled = true;
         this._bossMC.addEventListener(MouseEvent.CLICK,onBossClick);
         ToolTipManager.add(this._bossMC,"机械塔克林");
      }
      override public function destroy() : void
      {
         ToolTipManager.remove(this._bossMC);
         this._bossMC.removeEventListener(MouseEvent.CLICK,onBossClick);
      }
      private function onBossClick(e:MouseEvent):void
      {
         FightInviteManager.fightWithBoss("机械塔克林");
      }
   }
}

