package com.robot.core.effect.shotBehavior
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.ShotBehaviorManager;
   import com.robot.core.mode.PKArmModel;
   import com.robot.core.mode.SpriteModel;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.setTimeout;
   import org.taomee.utils.DisplayUtil;
   
   public class ShotEffect_143_3 implements IShotBehavior
   {
      private var modelMC:MovieClip;
      
      private var gunMC:MovieClip;
      
      private var bombMC:MovieClip;
      
      private var people:SpriteModel;
      
      private var armModel:PKArmModel;
      
      public function ShotEffect_143_3()
      {
         super();
         this.modelMC = ShotBehaviorManager.getMovieClip("shotEffect_143_3");
         this.bombMC = ShotBehaviorManager.getMovieClip("boomEffect_143_3");
         this.gunMC = ShotBehaviorManager.getMovieClip("gunEffect_143_3");
         this.modelMC["mc_1"].gotoAndStop(1);
         this.gunMC.gotoAndStop(1);
         this.bombMC.gotoAndStop(1);
      }
      
      public function shot(armModel:PKArmModel, sprite:SpriteModel) : void
      {
         this.armModel = armModel;
         this.people = sprite;
         var rect:Rectangle = armModel.getRect(armModel);
         if(armModel.isMirror)
         {
            this.modelMC.x = -rect.x;
            this.modelMC.scaleX = -1;
         }
         else
         {
            this.modelMC.x = rect.x;
            this.modelMC.scaleX = 1;
         }
         this.modelMC.y = rect.y;
         armModel.container.addChild(this.modelMC);
         armModel.hideBmp();
         this.modelMC["mc_1"].gotoAndPlay(2);
         setTimeout(this.showGun,900);
      }
      
      private function showGun() : void
      {
         var p:Point = this.people.localToGlobal(new Point());
         if(this.armModel.isMirror)
         {
            this.gunMC.x = p.x - 200;
            this.gunMC.scaleX = -1;
         }
         else
         {
            this.gunMC.x = p.x + 200;
            this.gunMC.scaleX = 1;
         }
         this.gunMC.y = p.y - 200;
         LevelManager.toolsLevel.addChild(this.gunMC);
         this.gunMC.gotoAndPlay(2);
         setTimeout(this.showBoom,2300);
      }
      
      private function showBoom() : void
      {
         this.armModel.showBmp();
         DisplayUtil.removeForParent(this.modelMC);
         DisplayUtil.removeForParent(this.gunMC);
         this.bombMC.x = this.people.x;
         this.bombMC.y = this.people.y;
         MapManager.currentMap.depthLevel.addChild(this.bombMC);
         this.bombMC.gotoAndPlay(2);
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeForParent(this.modelMC);
         DisplayUtil.removeForParent(this.gunMC);
         DisplayUtil.removeForParent(this.bombMC);
         this.modelMC = null;
         this.gunMC = null;
         this.bombMC = null;
         this.people = null;
         this.armModel = null;
      }
   }
}

