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
   
   public class MapProcess_36 extends BaseMapProcess
   {
      private var count:uint = 0;
      
      public function MapProcess_36()
      {
         super();
      }
      
      override protected function init() : void
      {
         OgreController.isShow = false;
         for(var i:uint = 0; i < 4; i++)
         {
            conLevel["pillar_" + i].gotoAndStop(1);
         }
         animatorLevel["lightMC"].gotoAndStop(1);
      }
      
      override public function destroy() : void
      {
         OgreController.isShow = true;
      }
      
      public function hitPillar(mc:MovieClip) : void
      {
         var effect:LightEffect;
         var id:uint = 0;
         var model:PetModel = MainManager.actorModel.pet;
         var b:Boolean = true;
         if(!model)
         {
            b = false;
         }
         else
         {
            id = uint(model.info.petID);
            if(PetXMLInfo.getType(id) != "5")
            {
               b = false;
            }
         }
         if(!b)
         {
            Alarm.show("这根柱子缺少启动电能，带上<font color=\'#ff0000\'>电系精灵</font>或许能激活它。");
            return;
         }
         mc.mouseEnabled = false;
         ++this.count;
         model.stop();
         effect = new LightEffect();
         effect.show(new Point(model.x,model.y - model.height + 2),new Point(mc.x + mc.width / 2,mc.y + mc.height - 5),false);
         setTimeout(function():void
         {
            mc.gotoAndStop(2);
         },1000);
         if(this.count >= 4)
         {
            OgreController.isShow = true;
         }
      }
   }
}

