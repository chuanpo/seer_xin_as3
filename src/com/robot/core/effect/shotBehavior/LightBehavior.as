package com.robot.core.effect.shotBehavior
{
   import com.robot.core.effect.LightEffect;
   import com.robot.core.mode.PKArmModel;
   import com.robot.core.mode.SpriteModel;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class LightBehavior implements IShotBehavior
   {
      public function LightBehavior()
      {
         super();
      }
      
      public function shot(armModel:PKArmModel, sprite:SpriteModel) : void
      {
         var light:LightEffect = new LightEffect();
         var rect:Rectangle = armModel.getRect(armModel);
         light.show(new Point(armModel.pos.x,armModel.pos.y + rect.y + 15),sprite.pos);
      }
      
      public function destroy() : void
      {
      }
   }
}

